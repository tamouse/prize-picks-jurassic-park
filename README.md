# README

Jurassic Park Safe Software: _nothing could go wrong, trust us._

Author: Tamara Temple <https://github.com/tamouse> <tamouse@gmail.com>
Date: 2023-02-17T16:22:31-0600

## Installation

### Pre-requesites ###

  1. ruby-install, the latest (`brew install ruby-install`)
  2. chruby, the latest (`brew install chruby`)
  3. Ruby version 3.2.0 (`ruby-install ruby 3.2.0`)
  4. Bundler version 2.4.6 (`gem install bundler`)
  5. Rails version 7.0.4.2 (`gem install rails`)
  6. SQLite 3 version 3.39.4 (`brew install sqlite3`)

### Cloning and setting up the app ###

Clone the project repo into a local working environment

    git clone https://github.com/tamouse/jurrassic_park.git jurrasic_park
    cd jurassic_park
    bundle
    bin/rails db:setup # creates and migrates the databases, seeds the app
    bin/rails s # starts up the server 
    
## Testing ##

There are a number of tests. Running tests is easy with:

    bin/rails test
    
## Environments ##

This project only supports the `:development` and `:test` environments.

> **There is no production environment.**

## Developer's Notes ##

I have completed all the business and technical requirements listed in the project description.

### Changes required for running concurrently ###

As is typical of a first-poss, the app is built to the concept that it's a monolith running in a single process, though it might run on multiple app servers. It doesn't pose any problems for this larval stage.

Putting this into a concurrent, multi-threaded environment would require that the database transactions be checked for allowing re-entrancy and being idempotent. In particular, I've noticed in several cases (here and in the past) that relationships can be problematic because different instances of models might be changing and said changes don't always get propagated in multi-threaded environments. Ideally, such issues can be handled using simple record transaction locking, but may in some cases require that the various instances understand when to refresh from the database after those transactions free up.

The biggest issue with that in this project is the relationships between cage and dinosaur. As I've implemented the operation to assign a dinosaur to a case as a service object, it would be a very good place to scrutinize the actions involved and try to make that as re-entrant and idempotent as possible. It would also require updating the test suit to allow for simulating multiple threads on processes running concurrently. Unfortunately, I'm not really aware of such tools, though I'm sure someone's thought of it. Running minitest in parallel can happen, but generally that is running different tests in parallel, and not a coordinated concurrent environment.

### Bonus changes ###

#### Implemented ####

I have implemented (so far):
  1. Cages know how many dinosaurs are contained. 
     
     I implemented a counter cache in the `Cage` model to keep track of the number dinosaurs currently assigned to the cage. 
     
     This wasn't strictly necessary given the nature of this project, the count is a given just from having the relationship, `cage.dinosaurs.size` gives the answer. The counter cache saves an extra query to the database 
     for the size count.
  2. Being able to query a list of dinosaurs for a particular cage. 
     
     This falls out by default when hitting the GET endpoint `/cages/:id` with a cage's ID field; the JSON blob returns all the relations of the specified cage.
  3. Automated tests for everything implemented. 
     
     While I don't always follow a strict TDD / BDD paradigm, those thoughts are sitting in my head often when I'm sketching out the initial bits of a model or controller, and the test comes soon after.
  
#### Not implemented ####

Items not done:
  1. Cages have a maximum capacity for how many dinosaurs it can hold. 
    
     To start off, determine a maximum number to be used for all the cages, and create it as a CONSTANT in an initializer. Add validations to verify that the maxium is not exceeded, in `Cage` (1st choice) or in `DinsosaurToCageService` (2nd choice, but kinda sketchy).
  2. Cages have a power status of ACTIVE or DOWN. 
      
     Add a boolean field to the `cages` table; make non-nullable with a default of `true`. Create methods in `Cage` to implement the `down`, `down!`, and `down?` methods, and hte `active`, `active!`, and `active?` operators.
  3. Cages cannot be powered off if they contain dinosaurs. 
      
     Using the `dinosaurs_count` counter cache if we trust it and never allow and `down!` operator when `dinosaur_count` is greater than zero.   
     
     [And of course, this is Jurassic Park -- there won't be any power outages, right? Right??]
  4. Dinosaurs cannot be moved to a cage that is powered down. 

     Add a validator to the `Cage` model to prevent this from happening.
  5. When querying dinosaurs or cages, they should be filterable or their attributes (Cages on power status, Dinosaurs on species). 
      
     This should be done via the controllers, when they get the index of Cages and Dinosaurs, and pass the filters in as `where` clauses. 
     
     It would be interesting also if, for example, the Dinosaurs controller was also nested under the Cages controller in order to provide a url path like "/cages/12/dinosaurs" (to give all the dinosaurs in cage 12) or "/cages/12/dinosaurs?species=triceratops" to select only the triceratops that are in cage 12.
