package com.visa.bo.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.stereotype.Component;

@Component
public class UtilDB {
    private final DataSource dataSource;

    public UtilDB(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Connection getConn() throws SQLException {
        return dataSource.getConnection();
    }
}
