
### Instructions for Using MultiSigWallet

**Description:**  `MultiSigWallet`  is a multi-signature wallet on Solidity 0.8.5,  
designed for secure asset management on Ethereum and BNB networks. It requires multiple owners (signatures)  
to approve transactions, making it an ideal solution for teams, DAOs, startups, or any group needing a high level  
of security and trust.  
**How it works:**  You specify a list of owners (e.g., 3 addresses) and the minimum number of signatures  
required (e.g., 2 out of 3) to send funds or call functions. Every transaction must be proposed, confirmed, and  
executed, eliminating single-point control and reducing the risk of hacks or errors.  
**Advantages:**  Protection against theft (one compromised key isn’t enough), transparency for all participants,  
flexible configuration (from 2 to dozens of signers), and compatibility with any ERC-20 tokens and ETH/BNB.  
**What it offers:**  Reliable joint asset management with minimal risk and maximum control.

**Compilation:**  Go to the "Deploy Contracts" page in BlockDeploy,  
paste the code into the "Contract Code" field (it requires no external imports),  
select Solidity version 0.8.5 from the dropdown menu,  
click "Compile" — the "ABI" and "Bytecode" fields will populate automatically.

**Deployment:**  In the "Deploy Contract" section:  
- Select the network (e.g., Ethereum Mainnet or BNB Chain),  
- Enter the private key of a wallet with ETH/BNB to pay for gas in the "Private Key" field,  
- Specify constructor parameters: a list of owner addresses (e.g.,  `["0xAddress1", "0xAddress2", "0xAddress3"]`)  
and the minimum number of signatures (e.g., 2),  
- Click "Deploy," review the network and fee in the modal window, and confirm.  
After deployment, you’ll get the wallet address (e.g.,  `0xYourMultiSigAddress`) in the BlockDeploy logs.

**How to Use MultiSigWallet:**  

-   **Fund the Wallet:**  Send ETH, BNB, or ERC-20 tokens to the contract address  
    (`0xYourMultiSigAddress`) using any wallet (MetaMask, Trust Wallet, etc.).
-   **Propose a Transaction:**  In the BlockDeploy interface, locate the contract in the logs, select the  
    `submitTransaction`  function,  
    specify: the recipient (e.g.,  `0xRecipient`), amount in wei (e.g., 1000000000000000000 for 1 ETH),  
    and data (leave as  `0x`  for simple ETH transfers), then call the function.
-   **Confirm the Transaction:**  Other owners must confirm the transaction via  
    `confirmTransaction`,  
    specifying the transaction ID (starts at 0 for the first one, visible in logs after submission).
-   **Execute the Transaction:**  After collecting the required signatures, call  
    `executeTransaction`  
    with the same transaction ID — the funds will be sent to the recipient.
-   **Check Status:**  Use  `getOwners`  
    to view the list of owners,  `getTransactionCount`  
    for the number of proposed transactions, or  `transactions`  
    with an ID for details of a specific transaction.

**Example Workflow:**  
- You created a wallet with 3 owners and 2 required signatures.  
- Owner 1 proposes sending 1 ETH to  `0xRecipient`  via  `submitTransaction`.  
- Owner 2 confirms it via  `confirmTransaction`  (ID 0).  
- Any owner calls  `executeTransaction`  (ID 0), and 1 ETH is sent.  
Without the second signature, the transaction won’t proceed, ensuring security.
