--dbms_java.grant_permission( 'KNEUMAN',
--'SYS:java.net.SocketPermission', 'oracle12c.informatik.uni-goettingen.de',
--'resolve' );

dbms_java.grant_permission( 'KNEUMAN','SYS:java.net.SocketPermission', '134.76.81.205:1521', 'connect,resolve' );

create or replace java source named "Code"
as

import java.sql.*;

public class DeleteRiver {
	
	public static void delRiver(String river) throws SQLException{
		Connection conn = null;
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
	    conn = DriverManager.getConnection("jdbc:default:connection:?allowMultiQueries=true");
		
		try {
	         Statement stmt = conn.createStatement();
		 conn.setAutoCommit(false);
		 stmt.addBatch("delete from river where name = '" + river+ "'");
		 stmt.addBatch("delete from geo_river where river ='"+ river +"'");
		 stmt.addBatch("delete from geo_source where river ='"+ river +"'");
		 stmt.addBatch("delete from geo_estuary where river = '" + river +"'");
   		 //stmt.addBatch("delete from river_through where river = '" + river +"'");
		 stmt.addBatch("update river set river = NULL where river ='"+river+"'");
	         stmt.addBatch("update lake set river = NULL where river ='"+river+"'");
	         stmt.addBatch("update located set river = NULL where river ='"+river+"'");
	         stmt.addBatch("delete from located where river is null and lake is null and lake is null");
		 int[] count= stmt.executeBatch();
		 conn.commit();
	         stmt.close(); 
		 conn.close();
	         
	      } catch (SQLException e) {
		
	         System.err.println(e.getMessage());}
	}
	public static void delLake(String lake) throws SQLException{
		Connection conn = null;
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
		
	  	conn = DriverManager.getConnection("jdbc:default:connection:?allowMultiQueries=true");
		
		try {
		Statement stmt = conn.createStatement();
		 conn.setAutoCommit(false);
	         stmt.addBatch("delete from lake where name = '" + lake+ "'");
		stmt.addBatch("delete from geo_lake where lake ='"+ lake +"'");
		//stmt.addBatch("delete from river_through where lake ='"+ lake +"'");
		stmt.addBatch("update located set lake = NULL where lake ='"+lake+"'");
		stmt.addBatch("update river set lake = NULL where lake ='"+lake+"'");
		stmt.addBatch("delete from located where river is null and lake is null and lake is null");
	        stmt.executeBatch();
		 conn.commit();
	         stmt.close(); 
		 conn.close();
	         
	      } catch (SQLException e) {
	         System.err.println(e.getMessage());}
		
	}
	public static void delSea(String sea) throws SQLException{
		Connection conn = null;
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
		conn = DriverManager.getConnection("jdbc:default:connection:?allowMultiQueries=true");
		
		try {

		Statement stmt = conn.createStatement();
		 conn.setAutoCommit(false);
	         stmt.addBatch("delete from sea where name = '" + sea+ "'");
		stmt.addBatch("delete from geo_sea where sea ='"+ sea +"'");
		stmt.addBatch("update located set sea = NULL where sea ='"+sea+"'");
		stmt.addBatch("delete from mergeswith set sea1 ='"+sea+"' or sea2 ='"+sea+"'");
		stmt.addBatch("update islandin set sea = NULL where sea ='"+sea+"'");
		stmt.addBatch("update river set sea = NULL where sea ='"+sea+"'");
		stmt.addBatch("delete from located where river is null and lake is null and lake is null");
	        stmt.executeBatch();
		 conn.commit();
	         stmt.close(); 
		 conn.close();
    
	         
	      } catch (SQLException e) {
	         System.err.println(e.getMessage());}
		
	}
};
/
