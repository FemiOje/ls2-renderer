use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address};
use openzeppelin_token::erc721::interface::{
    IERC721Dispatcher, IERC721DispatcherTrait, IERC721MetadataDispatcher,
    IERC721MetadataDispatcherTrait,
};
use ls2_renderer::nfts::ls2_nft::{IOpenMintDispatcher, IOpenMintDispatcherTrait};
use core::array::ArrayTrait;

fn deploy_contract() -> ContractAddress {
    let name: ByteArray = "Test NFT";
    let symbol: ByteArray = "TNFT";
    let base_uri: ByteArray = "https://example.com/";

    let contract = declare("ls2_nft").unwrap().contract_class();
    let mut calldata = array![];
    name.serialize(ref calldata);
    symbol.serialize(ref calldata);
    base_uri.serialize(ref calldata);
    let (contract_address, _) = contract.deploy(@calldata).unwrap();
    contract_address
}

#[test]
fn test_deployment() {
    let contract_address = deploy_contract();
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };

    assert(metadata_dispatcher.name() == "Test NFT", 'Wrong name');
    assert(metadata_dispatcher.symbol() == "TNFT", 'Wrong symbol');
}

#[test]
fn test_mint() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let erc721_dispatcher = IERC721Dispatcher { contract_address };
    let recipient = contract_address_const::<0x123>();

    // Mint a token
    mint_dispatcher.mint(recipient);

    // Check that the token was minted with ID 1
    assert(erc721_dispatcher.owner_of(1) == recipient, 'Wrong owner');
    assert(erc721_dispatcher.balance_of(recipient) == 1, 'Wrong balance');

    // Mint another token
    mint_dispatcher.mint(recipient);

    // Check that the token was minted with ID 2
    assert(erc721_dispatcher.owner_of(2) == recipient, 'Wrong owner');
    assert(erc721_dispatcher.balance_of(recipient) == 2, 'Wrong balance after 2nd mint');
}

#[test]
fn test_token_uri_returns_one() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
    let recipient = contract_address_const::<0x123>();

    // Mint a token
    mint_dispatcher.mint(recipient);

    // Get the token URI (should return "1")
    let uri = metadata_dispatcher.token_uri(1);

    // Verify it returns JSON metadata
    assert(uri.len() > 100, 'token_uri should return JSON');
    // Check it starts with data:application/json;base64
    assert(uri.at(0).unwrap() == 'd', 'should start with data');
}

#[test]
fn test_token_uri_different_ids() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
    let recipient = contract_address_const::<0x123>();
    
    mint_dispatcher.mint(recipient); // id 1
    mint_dispatcher.mint(recipient); // id 2
    
    let uri1 = metadata_dispatcher.token_uri(1);
    let uri2 = metadata_dispatcher.token_uri(2);
    
    // Both should return JSON but can be different
    assert(uri1.len() > 100, 'token_uri 1 should return JSON');
    assert(uri2.len() > 100, 'token_uri 2 should return JSON');
    // Different token IDs can return different metadata
}

#[test]
#[should_panic(expected: ('ERC721: invalid token ID',))]
fn test_token_uri_nonexistent_token() {
    let contract_address = deploy_contract();
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };

    // Try to get URI for a token that doesn't exist
    metadata_dispatcher.token_uri(999);
}

#[test]
fn test_multiple_mints_different_recipients() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let erc721_dispatcher = IERC721Dispatcher { contract_address };

    let recipient1 = contract_address_const::<0x123>();
    let recipient2 = contract_address_const::<0x456>();
    let recipient3 = contract_address_const::<0x789>();

    // Mint tokens to different recipients
    mint_dispatcher.mint(recipient1);
    mint_dispatcher.mint(recipient2);
    mint_dispatcher.mint(recipient3);
    mint_dispatcher.mint(recipient1); // Second token for recipient1

    // Verify ownership and balances
    assert(erc721_dispatcher.owner_of(1) == recipient1, 'Wrong owner of token 1');
    assert(erc721_dispatcher.owner_of(2) == recipient2, 'Wrong owner of token 2');
    assert(erc721_dispatcher.owner_of(3) == recipient3, 'Wrong owner of token 3');
    assert(erc721_dispatcher.owner_of(4) == recipient1, 'Wrong owner of token 4');

    assert(erc721_dispatcher.balance_of(recipient1) == 2, 'Wrong balance for recipient1');
    assert(erc721_dispatcher.balance_of(recipient2) == 1, 'Wrong balance for recipient2');
    assert(erc721_dispatcher.balance_of(recipient3) == 1, 'Wrong balance for recipient3');
}

#[test]
fn test_transfer_functionality() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let erc721_dispatcher = IERC721Dispatcher { contract_address };

    let owner = contract_address_const::<0x123>();
    let recipient = contract_address_const::<0x456>();

    // Mint a token
    mint_dispatcher.mint(owner);

    // Transfer the token
    start_cheat_caller_address(contract_address, owner);
    erc721_dispatcher.transfer_from(owner, recipient, 1);

    // Verify the transfer
    assert(erc721_dispatcher.owner_of(1) == recipient, 'Transfer failed');
    assert(erc721_dispatcher.balance_of(owner) == 0, 'Wrong owner balance');
    assert(erc721_dispatcher.balance_of(recipient) == 1, 'Wrong recipient balance');
}


#[test]
fn test_sample_token_uri() {
    let contract_address = deploy_contract();
    let mint_dispatcher = IOpenMintDispatcher { contract_address };
    let metadata_dispatcher = IERC721MetadataDispatcher { contract_address };
    let recipient = contract_address_const::<0x123>();

    // Mint a token
    mint_dispatcher.mint(recipient);

    // Get the token URI
    let uri = metadata_dispatcher.token_uri(1);

    // Should return JSON metadata
    assert(uri.len() > 100, 'should return JSON');

    println!("Token URI for token #1: {}", uri);
}
