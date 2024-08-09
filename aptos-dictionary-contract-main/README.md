Aptos Dictionary Contract
This module enables the creation and management of an on-chain dictionary where users can add definitions and update their author profiles. The dictionary is stored as a resource on the Aptos blockchain.

Features
Add Definitions: Users can contribute definitions to the dictionary, which are stored with the author's address and a timestamp.
Author Profiles: Users can create and update their author profiles, including a biography and a profile picture.
Prerequisites
Aptos CLI
Aptos blockchain account
Quick Start
1. Deploy the Module
Before using the dictionary, you must deploy this module to the Aptos blockchain.

shell
Copy code
$ aptos move publish
2. Initialize the Dictionary
After deploying, initialize the dictionary resource. This step can only be performed by the account that published the module.

shell
Copy code
$ aptos move run --function-id 'MODULE_ADDRESS::dictionary::init'
3. Add a Definition
Users can add new definitions to the dictionary by calling the add_definition function.

shell
Copy code
$ aptos move run --function-id 'MODULE_ADDRESS::dictionary::add_definition' --args 'string:WORD' 'string:CONTENT'
WORD: The word to be defined.
CONTENT: The definition of the word.
4. Update Author Profile
Authors can update their profiles by calling the update_profile function. The profile includes a biography and a profile picture.

shell
Copy code
$ aptos move run --function-id 'MODULE_ADDRESS::dictionary::update_profile' --args 'string:CURRENT_BIO' 'string:CURRENT_PIC' 'string:NEW_BIO' 'string:NEW_PIC'
CURRENT_BIO: Current biography.
CURRENT_PIC: Current profile picture.
NEW_BIO: New biography.
NEW_PIC: New profile picture.
Contract Overview
Constants
MODULE_ADDRESS: The address where the module is deployed. This address has special permissions for certain operations.
ERROR_UNAUTHORIZED: Error code for unauthorized access.
ERROR_NOT_INITIALIZED: Error code for when the dictionary resource is not initialized.
Structs
Dictionary: Represents the main dictionary resource containing a list of definitions and author profiles.
Definition: Stores details about a word, including its definition, the author’s address, and the timestamp.
AuthorProfile: Stores details about an author, including their address, biography, and profile picture.
Functions
init: Initializes the dictionary resource. Can only be called by the module's publisher.
add_definition: Adds a new definition to the dictionary.
update_profile: Updates the author's profile or creates a new one if it doesn't exist.