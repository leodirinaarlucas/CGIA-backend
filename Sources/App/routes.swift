import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let studentController = StudentController()
    try router.register(collection: studentController)
    
    let instructorController = InstructorController()
    try router.register(collection: instructorController)
    
    let courseController = CourseController()
    try router.register(collection: courseController)
}
