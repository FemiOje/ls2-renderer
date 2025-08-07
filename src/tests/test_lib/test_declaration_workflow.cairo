#[cfg(test)]
mod test_declaration_workflow {
    use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
    use starknet::ContractAddress;

    fn deploy_renderer_contract() -> ContractAddress {
        // First deploy a mock adventurer contract
        let mock_adventurer_contract = declare("mock_adventurer").unwrap().contract_class();
        let mut mock_calldata = array![];
        let (mock_adventurer_address, _) = mock_adventurer_contract.deploy(@mock_calldata).unwrap();

        let contract = declare("death_mountain_renderer").unwrap().contract_class();
        let mut calldata = array![];
        mock_adventurer_address.serialize(ref calldata);

        let (contract_address, _) = contract.deploy(@calldata).unwrap();
        contract_address
    }
}
