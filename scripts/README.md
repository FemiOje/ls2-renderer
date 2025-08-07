# LS2 Renderer Deployment Scripts

This directory contains scripts for declaring, deploying, and testing the LS2 Renderer smart contracts on Starknet.

## Quick Start

Run the complete workflow:

```bash
./full_workflow.sh
```

This will execute all steps from contract declaration to testing automatically.

## Individual Scripts

### Declaration Scripts

- **`declare_mock_contracts.sh`** - Declares mock adventurer and beast contracts
- **`declare_renderer_contract.sh`** - Declares the main Renderer contract

### Deployment Scripts

- **`deploy_mock_contracts.sh`** - Deploys the mock contracts (run after declaration)
- **`deploy_renderer_contract.sh`** - Deploys the Renderer contract with proper constructor arguments

### Testing Scripts

- **`test_contracts.sh`** - Comprehensive testing of all deployed contracts
- **`mint_nft.sh`** - Mint NFTs to specified addresses
- **`query_nft.sh`** - Query NFT metadata and information

### Utility Scripts

- **`full_workflow.sh`** - Complete end-to-end deployment workflow

## Generated Files

After running the scripts, you'll have these files with deployment information:

- `mock_contracts_class_hashes.txt` - Class hashes from mock contract declarations
- `mock_contracts_addresses.txt` - Addresses from mock contract deployments
- `nft_contract_class_hash.txt` - Class hash from NFT contract declaration
- `full_deployment_addresses.txt` - Complete deployment summary

## Usage Examples

### Step-by-Step Deployment

```bash
# 1. Declare mock contracts
./declare_mock_contracts.sh

# 2. Deploy mock contracts
./deploy_mock_contracts.sh

# 3. Declare NFT contract
./declare_renderer_contract.sh

# 4. Deploy NFT contract
./deploy_renderer_contract.sh

# 5. Test everything
./test_contracts.sh
```

### Minting and Querying

```bash
# Mint NFT to default address
./mint_nft.sh

# Mint NFT to specific address
./mint_nft.sh 0x1234567890abcdef...

# Query NFT metadata
./query_nft.sh 1
```

## Prerequisites

- Starknet Foundry (snforge/sncast) installed
- Account configured in `snfoundry.toml`
- Network access (sepolia testnet by default)
- Sufficient funds for transaction fees

## Configuration

The scripts use the configuration from `../snfoundry.toml`:

```toml
[sncast.default]
account = "renderer"
network = "sepolia"
```

## Constructor Arguments

The NFT contract requires the following constructor arguments:
- `name`: ByteArray - NFT collection name
- `symbol`: ByteArray - NFT symbol
- `base_uri`: ByteArray - Base URI for metadata
- `mock_adventurer_address`: ContractAddress - Mock adventurer contract address
- `mock_beast_address`: ContractAddress - Mock beast contract address

## Troubleshooting

1. **Permission Denied**: Run `chmod +x scripts/*.sh` to make scripts executable
2. **Account Not Found**: Configure your account in `snfoundry.toml`
3. **Class Hash Not Found**: Run declaration scripts before deployment
4. **Network Issues**: Check your network configuration and connectivity

## Security Notes

- These scripts are for development/testing purposes
- Always test on testnet before mainnet deployment
- Never commit private keys or sensitive data
- Verify all addresses and transaction details before mainnet use