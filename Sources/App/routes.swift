import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let studentController = StudentController()
    router.get("students", use: studentController.get)
    router.post("students","add", use: studentController.post)
    
    let instructorController = InstructorController()
    router.get("instructor", use: instructorController.get)
    router.post("instructor", "add", use: instructorController.post)
    
    let courseController = CourseController()
    router.get("course", use: courseController.get)
    router.post("course", "add", use: courseController.post)
}
