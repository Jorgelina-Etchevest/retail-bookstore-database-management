
import java.sql.*;

public class SeguridadEtapa4 {

    public static void main(String[] args) {

        // --- Datos de conexión ---
        String url = "jdbc:mysql://localhost:3306/tpi?serverTimezone=UTC";
        String usuario = "tpi_app";
        String contraseña = "UsuarioApp"; 

        try (Connection conexion = DriverManager.getConnection(url, usuario, contraseña)) {
            System.out.println("✅ Conexión exitosa como " + conexion.getMetaData().getUserName());

            // --- 1) Consulta segura con PreparedStatement ---
            String sqlConsulta = "SELECT pedido_id, numero, fecha, montoTotal, estado FROM pedido WHERE cliente_id = ?";
            try (PreparedStatement ps = conexion.prepareStatement(sqlConsulta)) {
                ps.setInt(1, 1); // Cliente 1
                ResultSet rs = ps.executeQuery();
                System.out.println("\nPedidos del cliente 1:");
                while (rs.next()) {
                    System.out.printf("ID: %d | Numero: %s | Fecha: %s | Total: %.2f | Estado: %s%n",
                            rs.getInt("pedido_id"),
                            rs.getString("numero"),
                            rs.getDate("fecha"),
                            rs.getDouble("montoTotal"),
                            rs.getString("estado"));
                }
            }

            // --- 2) Intento de inyección (no debería funcionar) ---
            String entradaMaliciosa = "1 OR 1=1";
            try (PreparedStatement psInyeccion = conexion.prepareStatement(sqlConsulta)) {
                // Intentamos pasar la cadena maliciosa como texto
                psInyeccion.setString(1, entradaMaliciosa);
                ResultSet rs2 = psInyeccion.executeQuery();
                System.out.println("\nIntento de inyección con entrada: '" + entradaMaliciosa + "'");
                while (rs2.next()) {
                    System.out.printf("ID: %d | Numero: %s%n", rs2.getInt("pedido_id"), rs2.getString("numero"));
                }
                System.out.println("✔ No se produjo inyección, la entrada se trató como dato.");
            } catch (SQLException e) {
                System.out.println("⚠ Intento de inyección bloqueado: " + e.getMessage());
            }

            // --- 3) Inserción segura de un nuevo pedido ---
            String sqlInsert = "INSERT INTO pedido (cliente_id, vendedor_id, numero, fecha, montoTotal, estado) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psInsert = conexion.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                psInsert.setInt(1, 1); // cliente_id
                psInsert.setInt(2, 1); // vendedor_id
                psInsert.setString(3, "JAVA-TEST-001");
                psInsert.setDate(4, java.sql.Date.valueOf("2025-10-20"));
                psInsert.setDouble(5, 150.00);
                psInsert.setString(6, "NUEVO");

                int filas = psInsert.executeUpdate();
                System.out.println("\nInserción segura realizada. Filas afectadas: " + filas);

                ResultSet claves = psInsert.getGeneratedKeys();
                if (claves.next()) {
                    System.out.println("Nuevo pedido_id generado: " + claves.getInt(1));
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en la conexión o SQL: " + e.getMessage());
        }
    }
}
