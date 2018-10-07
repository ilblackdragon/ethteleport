import os
import time
import argparse

from web3 import Web3
from solc import compile_source

STAKE = 1

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(SCRIPT_DIR)
LOCAL_NODE_ADDRESS = "http://127.0.0.1:8545"
IPC_FILEPATH = "/Users/zaver/Projects/hackaton/testnet1/chaindata/geth.ipc"
KEYFILE = "/Users/zaver/Projects/hackaton/testnet1/chaindata/keystore/UTC--2018-10-07T10-10-13.185517678Z--b0484a665307a831d2753a5fe23ba2e042ae39bf"
VOTING_CONTRACT = os.path.join(ROOT_DIR, 'contracts/Voting.sol')
NOTARY_PK = '0xB0484a665307A831D2753a5fe23Ba2E042aE39bf'
VOTING_CONTRACT_PK = '0x7bdb901b032e861e77a932c79ceb60667bc8660e'
PASSPTHRASE = '123456789'
CHAIN_ID = 15

if __name__ == "__main__":
    # We use IPC Provider in order to have an access to w3.personal.
    my_provider = Web3.IPCProvider(IPC_FILEPATH)
    w3 = Web3(my_provider)
    assert NOTARY_PK in w3.personal.listAccounts

    source_provider = Web3.IPCProvider(IPC_FILEPATH)
    source_w3 = Web3(source_provider)


    # Compile contract and get its instance.
    with open(VOTING_CONTRACT, 'r') as myfile:
        contract_source_code = myfile.read()
    compiled_sol = compile_source(contract_source_code)  # Compiled source code
    contract_interface = compiled_sol['<stdin>:Voting']
    voting_contract = w3.eth.contract(address=Web3.toChecksumAddress(VOTING_CONTRACT_PK), abi=contract_interface['abi'])

    # Get private key.
    with open(KEYFILE) as keyfile:
        encrypted_key = keyfile.read()
        private_key = w3.eth.account.decrypt(encrypted_key, PASSPTHRASE)

    prev_block_number = 0
    while True:
        time.sleep(1)
        # Get source block.
        block = source_w3.eth.getBlock('latest', full_transactions=True)
        if block.number <= prev_block_number:
            continue
        # Build a voting transaction.
        nonce = w3.eth.getTransactionCount(NOTARY_PK)
        tx = voting_contract.functions.put(str(block.number), block.transactionsRoot.hex()).buildTransaction({
            'chainId': CHAIN_ID,
            'gas': 70000,
            'gasPrice': w3.toWei('1', 'gwei'),
            'nonce': nonce,
            'value': STAKE
        })
        signed_tx = w3.eth.account.signTransaction(tx, private_key=private_key)
        w3.eth.sendRawTransaction(signed_tx.rawTransaction)

