import { ethers } from 'ethers';
import { abi, contractAddress } from "../Constants";

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


export default function Admin(){
    return(
        <div>
            <input id="ethAmount" placeholder="ETH Amount" />
            <button onClick={fund}>Fund</button>
        </div>
    );
}