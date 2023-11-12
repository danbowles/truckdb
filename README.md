# Welcome to TruckDB
✨ The Future of Food Truck Management (maybe)

##### A quick note:
This repository is inspired from the [Peck Engineering Assessment](https://github.com/peck/engineering-assessment)
## What is TruckDB?
In its current state, TruckDB is a simple-to-use and extensible food truck management API. It is build utilizing [Elixir](https://elixir-lang.org/), [Ecto](https://hexdocs.pm/ecto/Ecto.html) and [Absinthe](https://hexdocs.pm/absinthe/overview.html) with [PostreSQL](https://www.postgresql.org/) at the database layer.  Read on to hear about potential front-end user interface features of this application.
## Who is TruckDB for?
The core target audience for this application are city employees managing the status of their city's food trucks.
## Challenges Along the Way
As time was a limiting factor in this project, scope had to be limited greatly.  There is currently no front-end for this application.  One nice feature built into this application currently, however, is the GraphQL schema automatically recompiles when the Elixir code is compiled.  This makes it easier for a client-side GraphQL library to incorporate the schema.

Another issue encountered was cleaning up the comma-separated data into a PostgreSQL-friendly format.  Initially, this was done with some relatively straightforward regular expressions.  As it came closer to actually inserting the data, however, more issues were discovered.  Many of these were limited to formatting, thankfully.  Having the ability to do this again, a script would have been chosen to import and parse the file and properly create SQL-friendly output.

Initially, there was an attempt to seed the database using Elixir, but a migration with close to 500 rows proved too many.
## Project Structure
```
~/truckdb
├── data.sql
├── docker-compose.yml
└── truckdb
    ├── README.md
    ├── config
    ├── deps
    ├── lib
    ├── mix.exs
    ├── mix.lock
    ├── schema.graphql
    └── test
```
## Up and Running!
Let's get you setup to start looking at some food truck data!

### Clone this repository
`git clone git@github.com:danbowles/truckdb.git`

### Head into the repo's main directory and get Docker running:
`cd ~/truckdb`
`docker-compose up -d`

### Setup: Project Dependencies, Database Creation and Migration
`cd truckdb`
`mix setup`

### Seed Database With Data
#### *User and Password: `postgres`*
`psql -h localhost -U postgres -f ../data.sql`

### Start Managing Food Trucks!
`iex -S mix phx.server`

### Bonus: Run some tests
`mix test`
## Using Graphiql
Once the API is up and running, you can send your browser to:

http://localhost:4000/graphql/graphiql

Included in this tool is the ability to see what queries and mutations may be performed.  For convenience, they are listed below.
### Queries
```
getTruckById(id: ID!): Truck!
getTruckByLocationId(locationId: String!): Truck!
getTrucks: [Truck!]!
getTrucksByPermitStatus(status: PermitStatus!): [Truck!]!
```

### Mutations
```
createTruck(address: String!applicant: String!cnn: String!facilityType: FacilityType!locationId: String!permit: String!schedule: String!status: PermitStatus!): Truck!

deleteTruck(id: ID!): Truck!
updateTruckApplicant(applicant: String!id: ID!): Truck!
updateTruckFacilityType(facilityType: FacilityType!id: ID!): Truck!
updateTruckLatitudeLongitude(id: ID!latitude: String!longitude: String!): Truck!
```

## The Future of TruckDB
While this project is on good footing in terms of base functionality, the future is bright when it comes to managing food trucks.  Find some future feature ideas below:

### TruckDB API
* Fuzzy searching with multiple facets
* Paginated results
* Better unique constraints for things like Permits and truck location
* Quality of life endpoints
	* Permits expiring in 30 days
	* Food trucks with missing data (Location, hours, food items, etc)
* A separate Applicant management system
	* Some applicants have multiple trucks
	* Applicant contact info

### TruckDB Front-End
The future here is much more wide-open, but the overall goal is easy-of-use and useful features for truck management.

* A map view with all trucks across the city
	* Map pins will lead to management tools or modals and useful links to other municipal tools
	* Trucks near me
* A list view with filtering, sorting and searching
	* Search by applicant, permit status, city block, etc.
* Shortcuts for useful views
	* Trucks with lapsed permits
	* Permits per-block/sector
	* Trucks missing core information (location, hours, etc)
