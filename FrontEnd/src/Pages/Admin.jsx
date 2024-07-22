
import { ethers } from 'ethers';
import { abi, contractAddress } from "../Constants";

async function withdraw() {
    // Assuming you have the contract ABI and address
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    try {
      const transactionResponse = await contract.withdraw();
      await transactionResponse.wait();
      console.log("Withdrawal successful");
    } catch (error) {
      console.error(error);
    }
}

  async function fund() {
    const ethAmount = document.getElementById('ethAmount').value;
    // Assuming you have the contract ABI and address
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    try {
      const transactionResponse = await contract.fund({
        value: ethers.utils.parseEther(ethAmount),
      });
      await transactionResponse.wait();
      console.log("Funding successful");
    } catch (error) {
      console.error(error);
    }
  }

  async function getBalance() {
    if (typeof window.ethereum !== "undefined") {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      try {
        const balance = await provider.getBalance(contractAddress);
        console.log(ethers.utils.formatEther(balance));
      } catch (error) {
        console.error(error);
      }
    } else {
      alert("Please install MetaMask");
    }
  }


export default function Admin(){
    return(
        <>
            <div>
                <button onClick={withdraw}>Withdraw</button>
            </div>
            <div>
                <input id="ethAmount" placeholder="ETH Amount" />
                <button onClick={fund}>Fund</button>
            </div>
            <div>
                <button onClick={getBalance}>Get Balance</button>
            </div>
        </>
    );
}