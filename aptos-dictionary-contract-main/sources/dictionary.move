module aptos_dictionary_contract::dictionary {
    use std::string::String;
    use std::signer;
    use std::vector;
    use std::timestamp;

    /// The address that published the module. It also stores the dictionary resource.
    const MODULE_ADDRESS: address = @0x924a57c844cee4f0733134ecaf57bd82145df9a472f46940c558100a036e1908;

    /// The error to represent unauthorized operations.
    const ERROR_UNAUTHORIZED: u64 = 10;

    /// The error to represent the state where the dictionary resource is not initialized.
    const ERROR_NOT_INITIALIZED: u64 = 11;

    /// The main resource type to represent a dictionary on-chain.
    struct Dictionary has key {
        definitions: vector<Definition>,
        author_profiles: vector<AuthorProfile>, 
    }

    /// The type to represent a definition in the dictionary.
    struct Definition has store, drop, copy {
        word: String,
        content: String,
        author_addr: address,
        time: u64,
    }

    /// The type to represent an author profile in the dictionary.
    struct AuthorProfile has store, drop, copy {
        addr: address,
        biography: String,
        picture: String,
    }

    /// The entry function to initialize the dictionary resource.
    /// It can only be called by the address who published the module.
    public entry fun init(account: &signer) {
        // make sure the caller is the publisher of the module
        assert!(signer::address_of(account) == MODULE_ADDRESS, ERROR_UNAUTHORIZED);
        
        // create an empty dictionary resource
        let dictionary = Dictionary {
            definitions: vector[],
            author_profiles: vector[],
        };

        // store the resource in the account of the publisher of the module
        move_to(account, dictionary);
    }

    /// The entry function used to add new definitions in the dictionary.
    public entry fun add_definition(account: &signer, word: String, content: String) acquires Dictionary {
        // make sure the dictionary resource of the module address exists
        assert!(exists<Dictionary>(MODULE_ADDRESS), ERROR_NOT_INITIALIZED);

        // get the address of the signer
        let signer_addr = signer::address_of(account);

        // get the current Unix time in seconds
        let time = timestamp::now_seconds();

        // borrow the dictionary resource of the module address
        let dictionary = borrow_global_mut<Dictionary>(MODULE_ADDRESS);

        // create a new definition
        let new_definition = Definition {
            word: word,
            content: content,
            author_addr: signer_addr,
            time: time,
        };

        // add the new definition to the end of the definitions
        vector::push_back(&mut dictionary.definitions, new_definition);
    }

    /// The entry function used to update author profiles in the dictionary.
    public entry fun update_profile(account: &signer, current_biography: String, current_picture: String, new_biography: String, new_picture: String) acquires Dictionary {
        // make sure the dictionary resource of the module address exists
        assert!(exists<Dictionary>(MODULE_ADDRESS), ERROR_NOT_INITIALIZED);

        // borrow the dictionary resource of the module address
        let dictionary = borrow_global_mut<Dictionary>(MODULE_ADDRESS);

        // get the address of the signer
        let signer_addr = signer::address_of(account);

        // create the current profile
        let current_profile = AuthorProfile {
            addr: signer_addr,
            biography: current_biography,
            picture: current_picture,
        };

        // create the new profile
        let new_profile = AuthorProfile {
            addr: signer_addr,
            biography: new_biography,
            picture: new_picture,
        };

        // check if the signer has a profile, if so get its index
        let (is_in, index) = vector::index_of(&dictionary.author_profiles, &current_profile);

        if (is_in) {
            // the signer has a profile, so modify it
            let profile = vector::borrow_mut(&mut dictionary.author_profiles, index);
            *profile = new_profile; 
        } else {
            // the signer has no profile, so add the new profile 
            vector::push_back(&mut dictionary.author_profiles, new_profile);
        };
    }
}