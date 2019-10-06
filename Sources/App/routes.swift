import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let studentController = StudentController()
    router.get("students", use: studentController.index)
    router.post("students", use: studentController.create)
    router.patch("students", Student.parameter, use: studentController.update)
    router.delete("students", Student.parameter, use: studentController.delete)
    
    let instructorController = InstructorController()
    router.get("instructor", use: instructorController.index)
    router.post("instructor", use: instructorController.create)
    
    let courseController = CourseController()
    router.get("course", use: courseController.index)
    router.post("course", use: courseController.create)
}
