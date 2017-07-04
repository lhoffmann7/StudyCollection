import java.sql.*;

public class DeleteRiver {
	
	
	
	public static void delRiver(String river) throws SQLException{
		Connection conn = null;
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
		String url = "jdbc:oracle:thin:@//134.76.81.205:1521/dbis";
	    conn = DriverManager.getConnection(url,"kneuman","r31nm0uz3n");
		String statement = "delete from river where name = '" + river+ "'";
		try {
	         Statement stmt = conn.createStatement();
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "delete from geo_river where name ='"+ river +"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "delete from geo_source where river ='"+ river +"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement = "delete from geo_estuary where river = '" + river +"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement = "delete from river_though where river = '" + river +"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update located set river = NULL where river ='"+river+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update river set river = NULL where river ='"+river+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update lake set river = NULL where river ='"+river+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update located set river = NULL where river ='"+river+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement = "delete from located where river is null and lake is null and lake is null";
	         stmt.executeUpdate(statement);
	         stmt.close();
	         
	      } catch (SQLException e) {
	         System.err.println(e.getMessage());}
	}
	public static void delLake(String lake) throws SQLException{
		Connection conn = null;
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
		String url = "jdbc:oracle:thin:@//oracle12c.informatik.uni-goettingen.de:1521/dbis";
	    conn = DriverManager.getConnection(url,"kneuman","r31nm0uz3n");
		String statement = "delete from lake where name = '" + lake+ "'";
		try {
	         Statement stmt = conn.createStatement();
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "delete from geo_lake where name ='"+ lake +"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "delete from river_through where lake ='"+ lake +"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update located set lake = NULL where lake ='"+lake+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update river set lake = NULL where lake ='"+lake+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement = "delete from located where river is null and lake is null and lake is null";
	         stmt.executeUpdate(statement);
	         stmt.close();
	         
	      } catch (SQLException e) {
	         System.err.println(e.getMessage());}
		
	}
	public static void delSea(String sea) throws SQLException{
		Connection conn = null;
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
		String url = "jdbc:oracle:thin:@//oracle12c.informatik.uni-goettingen.de:1521/dbis";
	    conn = DriverManager.getConnection(url,"kneuman","r31nm0uz3n");
		String statement = "delete from sea where name = '" + sea+ "'";
		try {
	         Statement stmt = conn.createStatement();
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "delete from geo_sea where name ='"+ sea +"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update located set sea = NULL where sea ='"+sea+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "delete from mergeswith set sea1 ='"+sea+"' or sea2 ='"+sea+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update islandin set sea = NULL where sea ='"+sea+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement= "update river set sea = NULL where sea ='"+sea+"'";
	         stmt.executeUpdate(statement);
	         stmt.clearBatch();
	         statement = "delete from located where river is null and lake is null and lake is null";
	         stmt.executeUpdate(statement);
	         stmt.close();
	         
	      } catch (SQLException e) {
	         System.err.println(e.getMessage());}
		
	}
}
