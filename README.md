# Uala technical test. David Goyes. iOS Developer.
# Documentation

## Architecture

This app follows a monolithic architecture, organizing features into vertical layers, each further divided into three horizontal layers: *Presentation*, *Domain*, and *Infrastructure*. The project structure includes a primary feature (*Cities*) alongside shared *Common* functionality.
- The *Presentation* layer defines the user interface and what is displayed on the screen.
- The *Domain* layer contains domain models and business rules.
- The *Infrastructure* layer manages dependencies on external libraries, except those used for UI rendering in *Presentation*.

Each horizontal layer maintains its own DTOs, adhering to *SRP*, *Protected Variations*, and *Separation of Concerns*. This ensures that:
- Each view has a corresponding ViewModel.
- The Domain layer has its own models.
- The Infrastructure layer uses distinct DTOs for each dependency.

To maintain separation, models from *Infrastructure* (e.g., `APICity`) should not reach *Presentation*, and vice versa (e.g., `CityViewModel`).

## Cities' Infrastructure Layer

Cities' *Infrastructure* layer has three folders: *Database*, *Settings* and *Web*.

The URL from which cities are downloaded can be changed in the `Settings.plist` file, as a Data-Driven Approach. `PlistReader` allows to read a `plist` file from a given `Bundle`. Then, `SettingsRetriever` reads the content of the `Settings.plist` file as a `Dictionary`. This file must exist as it is a system precondition. Notice how the `SettingsRetriever` class conforms to the `SettingsRetrieverProtocol` protocol. Programming to an abstraction instead of an implementation allow to easily introduce automated tests, as well as increases flexibility and reduces coupling. Notice how `SettingsRetriever` references `PlistReader` through the `PlistReaderProtocol` protocol (according to `DIP`). This allows the easy usage of doubles in automated-tests. Afterwars, the actual production dependency can be created by means of a factory (i.e. `SettingsRetrieverFactory`).

Since cities shall be downloaded from a REST server, an API client is required. As a result, `APIClient` performs requests to any given URL and returns some `Decodable` result. Notice the introduction of the `downloadData(from url:)` internal method (which is not private) that encapsulates the call to `URLSession.shared.data()`. This getter method allows the `APIClient` to be easily tested, since it can be overriden in the test target and have a stub returned instead. This is based on the technique "subclass and override method". 
Working to an abstraction instead of an implementation let us introduce decorators, as is the case of `LoggingAPIClient`. The `fetchData` method invokes the same method on the decorated instance and then logs some messages in a logger. This is specially important, since logging messages to a logger should not be a responsability of APIClient. Therefore, logging should take place in decorators.
The class `DefaultCityListRemoteRepository` is a repository that performs the request to the server (via the `APIClient`) and then maps the resulting DTOs from the *Infrastructure* layer (i.e. `APICity`) to the ones from the *Domain* layer (i.e. `City`) with the `APIMapper`.
At the end, another factory (i.e. `CityListRemoteRepositoryFactory`) connects all the dependencies to perform the web request.

Entries marked as "favorite" should persist between app launches. Therefore, a local persistent soluction based on a `SwiftData` database was implemented. In order to improve the system cohesion, instead of one single class handling all the operations, these responsabilities are splitted in several clases (i.e. `DBCityCreator`, `DBCityLister` and `DBCityRemover`). Then, a facade (`DBFacade`) wrapps them all and reduces coupling by adding an indirection level. A repository (i.e. `DefaultCityLocalREpository`) handles the database usage, ensuring data integrity (e.g., preventing duplicate records) and enforcing uniqueness contraints. Once again, another factory (`CityListLocalRepositoryFactory`) connects all the dependencies for the local repository.

## Cities' Domain Layer

The abstractions for the Infrastructure's repository are defined here (i.e. `CityLocalRepository` and `CityRemoteRepository`). Take into account that the DTOs from that layer (e.g, `APICity`, `DBCity`) are not used in the interface of this repositories.

Business rules are defined as *Use Case*s, who are also known as "Actions" or "Interactors", depending on the implemented architecture. In my case, I'd rather calling them "Use Cases" since I feel more aligned with the architecture definition proposed by Craig Larman in "Applying UML and Patterns. An Introduction to Object-Oriented Analysis and Design and the Unified Process".
Toggling favorites, listing and filtering cities are business rules and, as a result, defined as "use cases" (`ToggleFavoriteUseCase`, `ListCitiesUseCase` and `FilterCitiesUseCase`, respectively). Notice how the use cases conform to the `Command` and `Resultable` protocols. These operations are separated at interface level according to the *Command-Query Responsibility Segregation* principle. In order to use these use cases, one must first inject the required input, execute it, and then extract the result. The `Command` interface also refers to the "Command" design-pattern from the GoF catalog.
Factories are used to create each Use case, except for `FilterCitiesUseCase` - Due to its simplicity, it is created without factory.

## Cities' Presentation Layer

My implementation of View-ViewModel is based on Larman's definition of the Controller GRASP-pattern and DDD's presenter. Since the View should not know the details of Domain's entities, the ViewModel has all the data that it needs. The ViewModel does not hold any direct reference to domain's entities, as it is sometimes implemented in the industry, but instead, it's created from the domain's entities by means of a factory.
`CityRowView` draws a title, a subtitle and a favorite icon. `CityList` draws a list of rows with a search-bar on top to allow the user to filter some items. `CityMap` draws a map centered on the city location. `HomeView` controls the navigation between the list and the map, or presents a `ProgressView` if the content is loading.

Some specials considerations were taken into account:
1. Due to the large amount of cities being loaded, Apple's native `List` view experienced some latency. As a result, a `LazyListView` was build with a nested combination of `ScrollView`, a `LazyVStack`, and a `ForEach`. This impelmentation has a better drawing performance.
2. Since the native `List` view was not used, Apple's native `NavigationSplitView` could not be used either. Therefore, a "home-made" version (`HomeMadeNavigationSplitView`) was implemented, in order to perform the master-detail behavior.

## Automated tests

This project uses unit test mostly, and has some integration tests. The test coverage is 90.3%. Some parts of the app were not tested because some preconditions did not required to do so, or some parts were too hard to test. In the latter case, the Martin-Fowler's Humble-Object testing pattern.
Some UI tests were created for illustration purposes. However, I'd rather have "snap-shot" tests instead. I did not write them since I required a third-party library.


## Glossary

- **SRP (Single Responsibility Principle):** A class should have only one reason to change, meaning it should have a single, well-defined responsibility. This improves maintainability, readability, and testability by reducing coupling and complexity.responsibility. This improves maintainability, readability, and testability by reducing coupling and complexity.
- **DTO (Data Transfer Object):** A simple, immutable object used to transfer data between layers or systems. It contains no business logic and is used to improve performance, maintain separation of concerns, and reduce dependencies.
- **Monolithic Architecture:** A software design where the entire application is built as a single, unified unit. All components (UI, business logic, and data access) are tightly integrated, making development and deployment simpler but potentially limiting scalability and flexibility.
- **Protected Variations (GRASP):** A design principle that reduces the impact of changes by encapsulating unstable aspects behind stable interfaces or abstractions. This minimizes dependencies and enhances maintainability.
- **Separation of Concerns (SoC):** A design principle that divides a system into distinct sections, each handling a specific responsibility. This improves modularity, maintainability, and scalability by reducing interdependencies.
- **Data-Driven Approach (Protected Variations)** A technique that minimizes the impact of changes by externalizing variable aspects (e.g., configurations, rules, or behaviors) into data structures instead of hardcoding them. This enhances flexibility and maintainability.
- **System Precondition:** A condition that must be true before a system or function executes to ensure correct behavior. Violating a precondition may lead to errors or undefined behavior.
- **Programming to an Abstraction:** A design principle where code depends on interfaces or abstract classes instead of concrete implementations. This improves flexibility, maintainability, and testability by reducing coupling.
- **DIP (Dependency Inversion Principle):** A SOLID principle stating that high-level modules should not depend on low-level modules; both should depend on abstractions. This reduces coupling and increases flexibility by promoting dependency on interfaces rather than concrete implementations.
- **Factory Pattern:** A creational design pattern (based on Pure Fabrication, GRASP) that provides an interface for creating objects without specifying their concrete classes. This promotes encapsulation, flexibility, and maintainability by centralizing object creation logic.
- **Subclass and Override Method:** A technique from "Working Effectively with Legacy Code" used to modify behavior in legacy systems by creating a subclass and overriding a method. This helps introduce changes without modifying the original code, facilitating testing and refactoring.
- **Decorator Pattern:** A structural design pattern (GoF) that allows behavior to be dynamically added to objects without modifying their code. It promotes flexibility and adherence to the Open/Closed Principle by wrapping objects in decorator classes.
- **Mapper:** A component or pattern that transforms data from one representation to another, often used to convert between domain models, DTOs, or database entities. It helps maintain separation of concerns and improves maintainability.
- **Facade Pattern:** A structural design pattern (GoF) that provides a simplified, unified interface to a complex subsystem. It improves usability, reduces dependencies, and promotes loose coupling by shielding clients from underlying complexities.
- **Indirection (GRASP):** A design principle that introduces an intermediary to decouple components, reducing direct dependencies. This improves flexibility, maintainability, and adaptability by enabling changes without affecting dependent modules.
- **Command-Query Responsibility Segregation (CQRS):** CQRS is a software architecture pattern that separates write operations (commands) from read operations (queries) to optimize performance, scalability, and maintainability.
    - **Command:** Modify system state (e.g., creating, updating, deleting data). Often require business rules and validation. Can trigger domain events or side effects.
    - **Query:** Retrieve data without modifying the system. Can be optimized for fast reads (e.g., denormalized views).
- **Actions:** In Domain-Driven Design (DDD), actions refer to operations that modify or interact with domain objects while enforcing business rules. They typically manifest as methods on domain entities, domain services, or application services.
    - **Entity Methods:** Actions that modify the state of an entity while maintaining invariants (business rules that must always hold). 
    - **Domain Services:** Actions that involve multiple entities or perform complex domain logic that doesn't naturally belong to a single entity.
    - **Application Services:** Actions that orchestrate domain logic but don’t contain business rules themselves. They usually coordinate domain services, repositories, and events.
* **Use Case:** In application architecture, a Use Case represents a specific business operation or workflow, defining how the system interacts with users or other systems. It encapsulates application logic, orchestrates domain operations, and ensures business rules are applied correctly. Often implemented as an Application Service in Domain-Driven Design (DDD).
* **Interactor:** In Clean Architecture, an Interactor is the core component of the Use Case layer, responsible for executing business logic and coordinating interactions between repositories, entities, and external services. It ensures that application rules are enforced while keeping the domain independent of frameworks and UI concerns.
- **Repository:** In Domain-Driven Design (DDD), a Repository is a design pattern that acts as an abstraction layer between the domain model and the data persistence mechanism. It provides a way to retrieve, store, and manage aggregates without exposing the underlying data source details. Examples of data source: a database or an API.
- **Command Pattern:** A behavioral design pattern (GoF) that encapsulates a request as an object, allowing parameterization, queuing, logging, and undo functionality. It promotes decoupling between senders and receivers of requests, improving flexibility and maintainability.
- **Presenter:** In DDD, a Presenter is responsible for formatting and preparing data from the Use Case (Domain Layer) before sending it to the View (Presentation Layer). It ensures separation of concerns by keeping business logic out of the UI.
- **Value Object:** In Domain-Driven Design (DDD), a *Value Object* is a lightweight, immutable object that represents a concept with no distinct identity but carries meaning through its attributes. Unlike Entities, which have an identity (id), Value Objects are defined by their values. Once value objects are created, they cannot be changed. Two Value Objects with the same values are considered equal. A value object can enforce rules and constraints (e.g. "Class invariants") and it ensures its own correctness when created.
- **Entity:** In Domain-Driven Design (DDD), an *Entity* is an object that is defined by its identity rather than its attributes. Even if its attributes change over time, it remains the same entity as long as its identity stays the same.
- **Humble Object:** A design technique that separates testable logic from hard-to-test components (e.g., UI, databases, or external dependencies). It moves logic into a separate, easily testable class while keeping the untestable part minimal, improving testability and maintainability.
- **Controller (GRASP):** A design pattern that assigns the responsibility of handling user input to a dedicated controller. It acts as an intermediary between the UI and the domain, coordinating requests, invoking business logic, and updating the view while maintaining separation of concerns.
- **Snapshot Tests:** A testing technique that captures the output of a component (e.g., UI, JSON, or data structures) and compares it to a previously stored "snapshot." If differences are detected, the test fails, helping to catch unintended changes in appearance or structure.
