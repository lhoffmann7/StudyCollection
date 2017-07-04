/*@lineinfo:filename=SQLJ*//*@lineinfo:user-code*//*@lineinfo:1^1*/import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import oracle.sqlj.runtime.Oracle;
import sqlj.runtime.ref.DefaultContext;

public class SQLJ {

	public static void main(String args[]) {
		
		try {
			//DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
			
			//DefaultContext ctx = new DefaultContext(con);
			//DefaultContext.setDefaultContext(ctx);
			Oracle.connect(SQLJ.class,"sqlj.props");
			
			int halfBIP;
			int addBIP=0;
			/*@lineinfo:generated-code*//*@lineinfo:20^4*/

//  ************************************************************
//  #sql { select sum(gdp)/2  from economy };
//  ************************************************************

{
  // declare temps
  oracle.jdbc.OraclePreparedStatement __sJT_st = null;
  sqlj.runtime.ref.DefaultContext __sJT_cc = sqlj.runtime.ref.DefaultContext.getDefaultContext(); if (__sJT_cc==null) sqlj.runtime.error.RuntimeRefErrors.raise_NULL_CONN_CTX();
  sqlj.runtime.ExecutionContext.OracleContext __sJT_ec = ((__sJT_cc.getExecutionContext()==null) ? sqlj.runtime.ExecutionContext.raiseNullExecCtx() : __sJT_cc.getExecutionContext().getOracleContext());
  oracle.jdbc.OracleResultSet __sJT_rs = null;
  try {
   String theSqlTS = "select sum(gdp)/2   from economy";
   __sJT_st = __sJT_ec.prepareOracleStatement(__sJT_cc,"0SQLJ",theSqlTS);
   if (__sJT_ec.isNew())
   {
     __sJT_st.setFetchSize(2);
   }
   // execute query
   __sJT_rs = __sJT_ec.oracleExecuteQuery();
   if (__sJT_rs.getMetaData().getColumnCount() != 1) sqlj.runtime.error.RuntimeRefErrors.raise_WRONG_NUM_COLS(1,__sJT_rs.getMetaData().getColumnCount());
   if (!__sJT_rs.next()) sqlj.runtime.error.RuntimeRefErrors.raise_NO_ROW_SELECT_INTO();
   // retrieve OUT parameters
   halfBIP = __sJT_rs.getInt(1); if (__sJT_rs.wasNull()) throw new sqlj.runtime.SQLNullException();
   if (__sJT_rs.next()) sqlj.runtime.error.RuntimeRefErrors.raise_MULTI_ROW_SELECT_INTO();
  } finally { if (__sJT_rs!=null) __sJT_rs.close(); __sJT_ec.oracleClose(); }
}


//  ************************************************************

/*@lineinfo:user-code*//*@lineinfo:20^54*/
			/*@lineinfo:generated-code*//*@lineinfo:21^4*/

//  ************************************************************
//  SQLJ iterator declaration:
//  ************************************************************

class Iter
extends sqlj.runtime.ref.ResultSetIterImpl
implements sqlj.runtime.NamedIterator
{
  public Iter(sqlj.runtime.profile.RTResultSet resultSet)
    throws java.sql.SQLException
  {
    super(resultSet);
    gdpNdx = findColumn("gdp");
    countryNdx = findColumn("country");
    m_rs = (oracle.jdbc.OracleResultSet) resultSet.getJDBCResultSet();
  }
  private oracle.jdbc.OracleResultSet m_rs;
  public int gdp()
    throws java.sql.SQLException
  {
    int __sJtmp = m_rs.getInt(gdpNdx);
    if (m_rs.wasNull()) throw new sqlj.runtime.SQLNullException(); else return __sJtmp;
  }
  private int gdpNdx;
  public String country()
    throws java.sql.SQLException
  {
    return (String)m_rs.getString(countryNdx);
  }
  private int countryNdx;
}


//  ************************************************************

/*@lineinfo:user-code*//*@lineinfo:21^46*/
			Iter iter;
			/*@lineinfo:generated-code*//*@lineinfo:23^4*/

//  ************************************************************
//  #sql iter = { select gdp as gdp,country  from economy, country  where code=country and gdp is not null order by gdp/population desc };
//  ************************************************************

{
  // declare temps
  oracle.jdbc.OraclePreparedStatement __sJT_st = null;
  sqlj.runtime.ref.DefaultContext __sJT_cc = sqlj.runtime.ref.DefaultContext.getDefaultContext(); if (__sJT_cc==null) sqlj.runtime.error.RuntimeRefErrors.raise_NULL_CONN_CTX();
  sqlj.runtime.ExecutionContext.OracleContext __sJT_ec = ((__sJT_cc.getExecutionContext()==null) ? sqlj.runtime.ExecutionContext.raiseNullExecCtx() : __sJT_cc.getExecutionContext().getOracleContext());
  try {
   String theSqlTS = "select gdp as gdp,country  from economy, country  where code=country and gdp is not null order by gdp/population desc";
   __sJT_st = __sJT_ec.prepareOracleStatement(__sJT_cc,"1SQLJ",theSqlTS);
   // execute query
   iter = new Iter(new sqlj.runtime.ref.OraRTResultSet(__sJT_ec.oracleExecuteQuery(),__sJT_st,"1SQLJ",null));
  } finally { __sJT_ec.oracleCloseQuery(); }
}


//  ************************************************************

/*@lineinfo:user-code*//*@lineinfo:23^134*/
			while (iter.next()){
				if (addBIP+iter.gdp() > halfBIP){
					double percentage = (double)(halfBIP-addBIP)/iter.gdp();
					System.out.println(iter.country() + " " + percentage);
					break;
				}
				addBIP = addBIP + iter.gdp();
                System.out.println(iter.country() + " 1");
				
			}
		} catch (SQLException e) {

		}
	}
}/*@lineinfo:generated-code*/