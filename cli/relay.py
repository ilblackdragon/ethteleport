import time
import argparse

from ethjsonrpc import EthJsonRpc


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--fromrpc", type=str, default="127.0.0.1:8545")
    parser.add_argument("--torpc", type=str, default="127.0.0.1:8546")
    parser.add_argument("--contract", type=str, default="0x123")
    parser.add_argument("--start", type=int, default=0)
    args, _ = parser.parse_known_args()

    from_ip, from_port = args.fromrpc.split(':')
    ctx_from = EthJsonRpc(from_ip, int(from_port))
    print("Connected " % args.fromrpc)

    to_ip, to_port = args.torpc.split(':')
    ctx_to = EthJsonRpc(to_ip, int(to_port))
    print("Connected " % args.torpc)

    last_block_index = args.start
    while True:
        block = ctx_from.eth_getBlockByNumber(last_block_index)
        if block:
            ctx_to.call_with_transaction(
                ctx_to.eth_coinbase(), args.contract, 'header(string)', [block["hash"]])
            last_block_index += 1
        else:
            time.sleep(1)
