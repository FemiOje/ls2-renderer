# LS2 Renderer Deployment Guide

This guide provides comprehensive instructions for declaring, deploying, and testing the LS2 Renderer smart contracts on Starknet.

## Overview

The LS2 Renderer project consists of three main contracts:
1. **Mock Adventurer Contract** - Provides test adventurer data
2. **Mock Beast Contract** - Provides test beast data  
3. **LS2 NFT Contract** - Main ERC721 contract with dynamic metadata rendering

## Prerequisites

- Starknet Foundry (snforge/sncast) installed
- Scarb build tool installed
- Account configured in snfoundry.toml (default: "renderer")
- Access to Starknet network (sepolia for testing)

## Quick Start

Run the complete workflow with a single command:

```bash
./scripts/full_workflow.sh
```

This will handle all steps from declaration to testing automatically.

## Manual Step-by-Step Process

### 1. Declare Mock Contracts

Declare the mock adventurer and beast contracts:

```bash
./scripts/declare_mock_contracts.sh
```

**What it does:**
- Builds the project with `scarb build`
- Declares `mock_adventurer` contract
- Declares `mock_beast` contract
- Saves class hashes to `scripts/mock_contracts_class_hashes.txt`

### 2. Deploy Mock Contracts

Deploy the mock contracts (no constructor arguments needed):

```bash
./scripts/deploy_mock_contracts.sh
```

**What it does:**
- Deploys mock_adventurer using its class hash
- Deploys mock_beast using its class hash
- Saves addresses to `scripts/mock_contracts_addresses.txt`

### 3. Declare NFT Contract

Declare the main NFT contract:

```bash
./scripts/declare_renderer_contract.sh
```

**What it does:**
- Builds the project
- Declares `ls2_nft` contract
- Saves class hash to `scripts/nft_contract_class_hash.txt`

### 4. Deploy NFT Contract

Deploy the NFT contract with constructor arguments:

```bash
./scripts/deploy_renderer_contract.sh
```

**What it does:**
- Deploys NFT contract with required constructor arguments
- Links to mock contract addresses
- Saves full deployment info to `scripts/full_deployment_addresses.txt`

### 5. Test All Contracts

Run comprehensive tests on all deployed contracts:

```bash
./scripts/test_contracts.sh
```

**What it does:**
- Tests mock contract functionality
- Tests NFT contract basic functions
- Performs test minting
- Validates metadata rendering

## Individual Operations

### Mint NFTs

Mint NFTs to specific addresses:

```bash
# Mint to default address
./scripts/mint_nft.sh

# Mint to specific address
./scripts/mint_nft.sh 0x1234567890abcdef...
```

### Query NFT Data

Get detailed information about specific NFTs:

```bash
# Query token ID 1
./scripts/query_nft.sh 1

# Query specific token ID
./scripts/query_nft.sh 5
```

## Constructor Arguments Documentation

### Mock Contracts

Both mock contracts have no constructor arguments:
- `mock_adventurer`: No constructor
- `mock_beast`: No constructor

### NFT Contract

The `ls2_nft` contract constructor requires:

```cairo
constructor(
    ref self: ContractState,
    name: ByteArray,           // "Loot Survivor 2.0"
    symbol: ByteArray,         // "LS2"
    base_uri: ByteArray,       // "https://loot-survivor.io/nft/"
    adventurer_contract: ContractAddress,  // Only adventurer contract needed
)
```

**Serialization format used:**
- `name`: `0x4c6f6f74205375727669766f7220322e30` (hex-encoded "Loot Survivor 2.0")
- `symbol`: `0x4c533220` (hex-encoded "LS2")
- `base_uri`: `0x68747470733a2f2f6c6f6f742d7375727669766f722e696f2f6e66742f` (hex-encoded URL)
- `adventurer_contract`: Contract address from adventurer deployment

## ByteArray Serialization

Cairo ByteArray serialization for constructor arguments:

### Simple String Encoding
For strings that fit in a single felt252 (< 31 bytes), use hex encoding:

```bash
# "Hello" -> 0x48656c6c6f
echo -n "Hello" | xxd -p
```

### Complex ByteArray Format
For longer strings, use the full ByteArray format:
```
[num_full_words, full_words..., pending_word, pending_word_len]
```

## File Structure

After running the deployment scripts, you'll have:

```
scripts/
├── declare_mock_contracts.sh         # Declare mock contracts
├── deploy_mock_contracts.sh          # Deploy mock contracts
├── declare_renderer_contract.sh      # Declare Renderer contract
├── deploy_renderer_contract.sh       # Deploy Renderer contract
├── test_contracts.sh                 # Test all contracts
├── mint_nft.sh                       # Mint NFTs
├── query_nft.sh                      # Query NFT data
├── full_workflow.sh                  # Complete workflow
├── mock_contracts_class_hashes.txt   # Mock contract class hashes
├── mock_contracts_addresses.txt      # Mock contract addresses
├── nft_contract_class_hash.txt       # NFT contract class hash
└── full_deployment_addresses.txt     # All contract addresses
```

## Testing

### Unit Tests

Run the project's unit tests:

```bash
scarb test
```

### Integration Tests

The deployment scripts include integration tests that verify:
- Contract deployment success
- Mock contract functionality
- NFT minting and metadata generation
- Cross-contract interactions

### Manual Testing

Use the provided scripts to manually test specific functionality:

```bash
# Test adventurer data
sncast --account renderer call \
  --contract-address [MOCK_ADVENTURER_ADDRESS] \
  --function get_adventurer \
  --calldata 0x1

# Test beast data
sncast --account renderer call \
  --contract-address [MOCK_BEAST_ADDRESS] \
  --function get_beast \
  --calldata 0x1

# Test NFT metadata
sncast --account renderer call \
  --contract-address [NFT_ADDRESS] \
  --function token_uri \
  --calldata 0x1
```

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Ensure Scarb is installed and up to date
   - Check that all dependencies are available
   - Run `scarb clean` and rebuild

2. **Declaration Failures**
   - Verify account configuration in `snfoundry.toml`
   - Check network connectivity
   - Ensure sufficient funds for fees

3. **Deployment Failures**
   - Verify class hashes exist in the generated files
   - Check constructor argument format
   - Ensure mock contracts are deployed first

4. **Test Failures**
   - Wait for transactions to be confirmed
   - Check contract addresses in generated files
   - Verify account has necessary permissions

### Error Messages

- `Class hash not found`: Run declaration scripts first
- `Contract not found`: Check deployment addresses
- `Invalid constructor arguments`: Verify serialization format
- `Account not found`: Configure account in snfoundry.toml

## Network Configuration

The scripts use the account configuration from `snfoundry.toml`:

```toml
[sncast.default]
account = "renderer"
network = "sepolia"
```

To use different networks or accounts, either:
1. Modify `snfoundry.toml`
2. Use command-line overrides: `sncast --account myaccount --network mainnet`

## Security Considerations

- Never commit private keys or sensitive data
- Use testnet for initial testing
- Verify contract addresses before mainnet deployment
- Test all functionality thoroughly before production use

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review the Cairo and Starknet documentation
3. Verify all prerequisites are met
4. Check network status and account configuration