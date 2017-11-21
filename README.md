# Introduction
The serverless framework project provides a great way to manage the deployment and management of FaaS microservices as well as the related infrastructure with cloud providers. It does not, however, provide a structured way to build a microservice including features such as unit testing, ORM, and just providing a basic directory structure to keep the layout of each microservice consistent; something a lot of other frameworks do provide.

This project aims to fill that gap by putting together numerous other NPM packages to provide features useful to a microservice in general (such as mocha for unit testing, sequelize for ORM), as well as Typescript and a src/dist setup for function builds.

# Future Plans
Eventually, this code base will probably form part of a custom cli tool to provide consistency when performing functions such as initialising a new function, adding a new database model, etc. For now, the various packages provide their cli tools

# Features
The framework includes:
* Serverless framework for function and cloud service orchestration (https://serverless.com/)
* sequelize and sequelize-cli to help manage an RDBMS and to act as an ORM (https://github.com/sequelize/sequelize and https://github.com/sequelize/cli)
* mocha to provide unit testing capabilities for each microservice. (https://mochajs.org/)
* serverless-offline to allow for spinning up a test web server to test RPC endpoints. (https://github.com/dherault/serverless-offline)
* typescript to make writing code better (https://www.typescriptlang.org/)
* Vagrant in order to assist in running tests in an environment more closely matching those of your cloud provider. (https://www.vagrantup.com/)
* serverless-mocha-plugin assists with integrating testing into the serverless cli ( https://github.com/SC5/serverless-mocha-plugin )

# Getting Started
Once you have checked out the repository the following steps are recommended to personalise your new microservice:

1. Run ```rm .git/ -rf``` to remove the reference to this repository and then ```git init``` to create your new repo for your own project.
1. Open /Vagrantfile and tweak any network and memory settings you need to for your own testing environment and to more closely match what your cloud provider gives you. These settings do not effect any deployed code and is purely as a develop convenience.
1. Open /serverless.yml and edit the name of your service on line 14, and your provider settings if necessary under the provider section from line 20. For additional information about the serverless.yml file take a look at https://serverless.com/framework/docs/providers/aws/guide/serverless.yml/

Now you may begin development. What you need to do next depends on how you like to work as a developer. The folder structure is very simple and pretty consistent with how other frameworks tend to lay things out. All development for your own microservice is done within the src/ directory. The directories within are:

* functions: This is where your functions themselves will live.
* migrations: This is a db related feature that allows management of changes to the database over time and is part of the sequelize-cli package.
* models: Another db related feature where the various table schema's in your database are described using sequelize.
* seeders: Yet another db related feature. Seeders are datafiles used to initialise the database with content usually for testing purposes.
* test: this is where the unit tests live and the directory structure within should follow the directory structure outside. For example, if a unit test for a function is going to be written, it should be located within test/functions

# Creating a new function
Because of the [serverless-mocha](https://github.com/SC5/serverless-mocha-plugin) plugin, we can use a cli command to help us get started with a pre-defined template for the function as well as the test. The function will be created in ```/src/functions``` based on the functions template in ```/templates``` and the test will be created in ```/src/test/functions``` based on the template in ```/templates```. serverless-mocha does not, however, provide support for Typescript so, while the templates are coded using Typecsript, you will need to manually edit the extensions to the function and its corresponding test from ```.js``` to ```.ts```

