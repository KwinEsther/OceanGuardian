# SupplyChainVerify

SupplyChainVerify is a blockchain-based solution built on the Stacks blockchain that enables transparent verification and tracking of products throughout the entire supply chain.

## Features

- **Product Registration**: Manufacturers can register their products with detailed information
- **Transparent Tracking**: Complete visibility of production processes and manufacturing details
- **Third-party Verification**: Independent inspectors can verify product information
- **Immutable Records**: Blockchain-based records ensure data integrity

## Smart Contract Functions

### Administration
- `add-inspector`: Register authorized inspectors who can verify product information

### Manufacturer Functions
- `register-product`: Add a new product with production details and manufacturing information
- `get-manufacturer-products`: View all products registered by a specific manufacturer

### Verification
- `verify-product`: Authorized inspectors can validate product information
- `is-inspector`: Check if an address is an authorized inspector

### Data Retrieval
- `get-product`: View complete details about a specific product

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet) for local development
3. Run `clarinet check` to verify the contract
4. Deploy using Clarinet or the Stacks CLI

## For Manufacturers

Manufacturers can register their products by providing:
- Product name
- Production process details
- Manufacture date
- Factory location

## For Inspectors

Authorized inspectors can review and verify products, providing consumers with confidence in the manufacturing processes used.