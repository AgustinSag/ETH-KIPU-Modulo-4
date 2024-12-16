// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleDEX {    //AgustinS
    //Variables
    IERC20 public tokenA;
    IERC20 public tokenB;
    address public owner;

    //Eventos
    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event TokensSwapped(address trader, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(uint256 amountA, uint256 amountB);

    constructor(address _tokenA, address _tokenB){
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);        
        owner = msg.sender;
    }       

    //Modificadores
    modifier onlyOwner() {  //modificador para validar que el solicitante sea el owner
        require(msg.sender == owner, "Solo el owner puede ejecutar esta funcion.");
        _; // Continúa con la ejecución de la función modificada
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external payable onlyOwner {
        //tokenA.transfer(to, value);
        //tokenA.transferFrom(from, to, value);
        tokenA.transferFrom(owner, address(this), amountA);
        tokenB.transferFrom(owner, address(this), amountB);
        emit LiquidityAdded(amountA, amountB);
    }
    function swapAforB(uint256 amountAIn) external payable {
        uint X0 = tokenA.balanceOf(address(this));
        uint Y0 = tokenB.balanceOf(address(this));
        uint dY = Y0 - (X0 * Y0) / (X0 + amountAIn);
        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, dY);
        emit TokensSwapped(msg.sender, amountAIn, dY);
    }
    function swapBforA(uint256 amountBIn) external payable {
        uint X0 = tokenA.balanceOf(address(this));
        uint Y0 = tokenB.balanceOf(address(this));
        uint dX = (X0 * Y0) / (Y0 - amountBIn) - X0;
        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, dX);
        emit TokensSwapped(msg.sender, dX, amountBIn);
    }
    function removeLiquidity(uint256 amountA, uint256 amountB) external payable onlyOwner {
        //tokenA.transfer(to, value);
        //tokenA.transferFrom(from, to, value);
        tokenA.transfer(owner, amountA);
        tokenB.transfer(owner, amountB);
        emit LiquidityRemoved(amountA, amountB);
    }
    function getPrice(address _token) external view returns (uint price) {
        require((_token == address(tokenA)) || (_token == address(tokenB)), "Token invalido.");

        if (_token == address(tokenA)) {
            //return (((tokenB.balanceOf(address(this)))/(tokenA.balanceOf(address(this)))));
            return (((tokenB.balanceOf(address(this))*100)/(tokenA.balanceOf(address(this)))*100)/100);
        }        
        if (_token == address(tokenB)) {
            //return (((tokenA.balanceOf(address(this)))/(tokenB.balanceOf(address(this)))));
            return (((tokenA.balanceOf(address(this))*100)/(tokenB.balanceOf(address(this)))*100)/100);
        }        
    }
}