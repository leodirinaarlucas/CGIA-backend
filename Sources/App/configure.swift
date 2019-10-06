import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    try services.register(FluentPostgreSQLProvider())

    // Configure the rest of your application here
    
    if let url = Environment.get("DATABASE_URL") {
        if let postgreSQLConfig = PostgreSQLDatabaseConfig(url: url) {
            services.register(postgreSQLConfig)
        }
    } else {
        let postgreSQLConfig = PostgreSQLDatabaseConfig(hostname: "127.0.0.1", port: 5432, username: "carneiro", database: "CGIAdb", password: nil)
        services.register(postgreSQLConfig)
    }
    
    
    var migrations = MigrationConfig()
    migrations.add(model: Student.self, database: .psql)
    migrations.add(model: Course.self, database: .psql)
    migrations.add(model: Instructor.self, database: .psql)
    migrations.add(model: StudentCourse.self, database: .psql)
    services.register(migrations)
}
