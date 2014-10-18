package com.cyou.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class ConnectionUtil {
	private static String[] props = { "com.mysql.jdbc.Driver",
			"jdbc:mysql://127.0.0.1:3306/admin?useUnicode=true&characterEncoding=UTF-8", "root", "passw0rd"};
	static {
		try {
			// 加载驱动
			Class.forName(props[0]).newInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 获取连接方法
	public static Connection getConnection() {
		Connection con = null;
		try {
			con = DriverManager.getConnection(props[1], props[2], props[3]);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}

	// 释放连接方法
	public static void release(ResultSet rs, Statement stmt, Connection con) {
		if (rs != null) {
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			if (stmt != null) {
				try {
					stmt.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		if (con != null) {
			try {
				con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	// 释放单个对象方法
	public static void release(Object obj) {
		if (obj instanceof Connection) {
			try {
				((Connection) obj).close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (obj instanceof Statement) {
			try {
				((Statement) obj).close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (obj instanceof ResultSet) {
			try {
				((ResultSet) obj).close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public static void main(String[] args) {
		// ..................
	}

}
