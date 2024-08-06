// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GasMeasurement {
    IERC20 public usdcToken;
    address public receiverAddress;

    constructor(address _usdcToken, address _receiverAddress) {
        usdcToken = IERC20(_usdcToken);
        receiverAddress = _receiverAddress;
    }

    function ccipReceive(bytes memory data) public {
        uint256 startGas = gasleft();

        // Logic for ccipReceive function goes here
        // For example, we can decode data and perform actions based on it.

        uint256 gasUsed = startGas - gasleft();
        emit GasUsed(gasUsed);
    }

    function transferUsdc(uint256 amount) public {
        uint256 gasLimit = calculateGasLimit();
        usdcToken.transfer(receiverAddress, amount);

        emit TransferCompleted(amount, gasLimit);
    }

    function calculateGasLimit() internal view returns (uint256) {
        uint256 baseGasConsumption = measureGasConsumption();
        return (baseGasConsumption * 110) / 100; // Increase by 10%
    }

    function measureGasConsumption() internal returns (uint256) {
        uint256 startGas = gasleft();
        ccipReceive(""); // Call with empty data for measurement
        uint256 gasUsed = startGas - gasleft();
        return gasUsed;
    }

    event GasUsed(uint256 gasUsed);
    event TransferCompleted(uint256 amount, uint256 gasLimit);
}
