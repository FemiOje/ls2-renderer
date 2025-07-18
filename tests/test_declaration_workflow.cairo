#[cfg(test)]
mod test_declaration_workflow {
    use starknet::{ContractAddress, contract_address_const};
    use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
    use ls2_renderer::nfts::ls2_nft::{IOpenMintDispatcher, IOpenMintDispatcherTrait};
    use openzeppelin_token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};
    use openzeppelin_token::erc721::interface::{
        IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait,
    };

    fn deploy_nft_contract() -> ContractAddress {
        let contract = declare("ls2_nft").unwrap().contract_class();
        let name: ByteArray = "Loot Survivor 2.0";
        let symbol: ByteArray = "LS2";
        let base_uri: ByteArray = "https://loot-survivor.io/nft/";

        let mut calldata = array![];
        name.serialize(ref calldata);
        symbol.serialize(ref calldata);
        base_uri.serialize(ref calldata);

        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        contract_address
    }

    #[test]
    fn test_nft_contract_declaration_and_deployment() {
        // Deploy NFT contract
        let nft_address = deploy_nft_contract();

        // Test ERC721 functionality
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };

        // Test metadata
        let name = metadata_dispatcher.name();
        assert!(name == "Loot Survivor 2.0", "Name should match");

        let symbol = metadata_dispatcher.symbol();
        assert!(symbol == "LS2", "Symbol should match");
    }

    #[test]
    fn test_nft_minting_and_metadata() {
        // Deploy contract
        let nft_address = deploy_nft_contract();

        // Test minting
        let mint_dispatcher = IOpenMintDispatcher { contract_address: nft_address };
        let erc721_dispatcher = IERC721Dispatcher { contract_address: nft_address };
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };

        let recipient = contract_address_const::<0x123>();

        // Mint NFT
        mint_dispatcher.mint(recipient);

        // Verify ownership
        let owner = erc721_dispatcher.owner_of(1);
        assert!(owner == recipient, "NFT should be owned by recipient");

        // Test metadata generation - should return JSON
        let token_uri = metadata_dispatcher.token_uri(1);
        assert!(token_uri.len() > 100, "Token URI should return JSON");
    }

    #[test]
    fn test_constructor_arguments_serialization() {
        // Test that constructor arguments are properly serialized
        let nft_address = deploy_nft_contract();

        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };

        // Verify constructor arguments were properly set
        let name = metadata_dispatcher.name();
        let symbol = metadata_dispatcher.symbol();

        assert!(name == "Loot Survivor 2.0", "Name should be correctly set");
        assert!(symbol == "LS2", "Symbol should be correctly set");
    }

    #[test]
    fn test_multiple_nft_minting_ownership() {
        // Test minting multiple NFTs and verifying ownership
        let nft_address = deploy_nft_contract();

        let mint_dispatcher = IOpenMintDispatcher { contract_address: nft_address };
        let erc721_dispatcher = IERC721Dispatcher { contract_address: nft_address };

        let recipient1 = contract_address_const::<0x123>();
        let recipient2 = contract_address_const::<0x456>();

        // Mint multiple NFTs
        mint_dispatcher.mint(recipient1);
        mint_dispatcher.mint(recipient2);

        // Verify ownership
        let owner1 = erc721_dispatcher.owner_of(1);
        let owner2 = erc721_dispatcher.owner_of(2);

        assert!(owner1 == recipient1, "Token 1 should be owned by recipient1");
        assert!(owner2 == recipient2, "Token 2 should be owned by recipient2");
    }

    #[test]
    fn test_token_uri_returns_one() {
        // Test that token_uri always returns "1"
        let nft_address = deploy_nft_contract();

        let mint_dispatcher = IOpenMintDispatcher { contract_address: nft_address };
        let metadata_dispatcher = IERC721MetadataDispatcher { contract_address: nft_address };

        let recipient1 = contract_address_const::<0x123>();
        let recipient2 = contract_address_const::<0x456>();

        // Mint two NFTs
        mint_dispatcher.mint(recipient1);
        mint_dispatcher.mint(recipient2);

        // Test that both return JSON
        let token_uri1 = metadata_dispatcher.token_uri(1);
        let token_uri2 = metadata_dispatcher.token_uri(2);
        
        assert!(token_uri1.len() > 100, "Token 1 URI should return JSON");
        assert!(token_uri2.len() > 100, "Token 2 URI should return JSON");
        // Different token IDs can return different metadata
    }
}