# Foundify — Lost it? Foundify it.

**MG3012: Blockchain Technology for Business — Assignment 2**  
**University:** FAST-NUCES Islamabad Campus  
**Network:** Ethereum Sepolia Testnet (chain ID `11155111`)  
**Project type:** Solidity smart contract + one-page HTML/CSS/JavaScript dApp

Foundify is a campus lost-and-found application. Students can report lost or found belongings, browse real blockchain records, and request a claim. The wallet that created a report is the only one that can reject a pending claim or mark the report resolved after an in-person return.

> This is a student demonstration, **not** an official FAST service. Wallet addresses do not prove real-world ownership. Do not publish sensitive personal information.

## 1. Project files

```text
Foundify/
├── SmartContract.sol               Solidity contract (five functions)
├── index.html                      Single-page frontend with inline JavaScript
├── style.css                       Friendly green / cream design
├── assets/
│   ├── foundify-logo.svg
│   └── hero-illustration.svg
├── README.md
└── screenshots/
    └── README.md                   Instructions for adding three REAL screenshots
```

## 2. Smart contract address

- **Sepolia contract address:** `0x7Fe04661cf5d19a458617065817C845BB352fA5A`
- **Sepolia Etherscan contract URL:** `https://sepolia.etherscan.io/tx/0x3c736634fb63c9827594fa87a216a96683dd3480c57b7c1c2a0954ff98b44bd3`
- **Public GitHub repository:** `https://github.com/Ibrahim245529/Foundify`

These values must be filled in **after you deploy**. No placeholder is a deployed address. The frontend lets you paste the address into the **One-time Project Setup** box; it saves the address in this browser's local storage. There is no need to edit JavaScript just to set the address.

## 3. How it works

1. **Report:** Connect MetaMask on Sepolia. Select Lost or Found. Enter item name, category, location, description, approximate date, and a preferred public handover spot. Publish via a transaction.
2. **Browse:** Anyone can search/filter existing blockchain reports. Viewing and filtering does not require paying gas.
3. **Claim:** A different wallet can click **I Found This** (for a Lost report) or **This Is Mine** (for a Found report). Only one claim can be pending per report.
4. **Handover:** Students coordinate the physical return outside the app and use a public campus handover point. A wallet claim alone is not proof of ownership.
5. **Review:** The original reporter uses MetaMask to **Reject claim** (back to Open) or **Confirm returned** (Resolved). Resolved items cannot be claimed again.

### Status flow

```text
OPEN --requestClaim()--> CLAIM PENDING --reviewClaim(false)--> OPEN
                                  \
                                   --reviewClaim(true)--> RESOLVED
```

### The five functions in SmartContract.sol

| Function | Read / Write | Explanation |
| --- | --- | --- |
| `reportItem(...)` | Write | Stores a new report; `msg.sender` becomes the reporter; emits `ItemReported`. |
| `getItem(itemId)` | Read | Returns the item, reporter, claimant, and status. |
| `getTotalItems()` | Read | Returns the total report count for the list and dashboard. |
| `requestClaim(itemId)` | Write | Allows a different wallet to submit the one pending claim; emits `ClaimRequested`. |
| `reviewClaim(itemId, returned)` | Write | Reporter only: `false` rejects and reopens, `true` resolves after handover; emits `ClaimReviewed`. |

The contract uses an `Item` struct, a private `mapping` from item ID to Item, `ReportType` (`Lost=0`, `Found=1`), and `Status` (`Open=0`, `ClaimPending=1`, `Resolved=2`).

### Real FAST Islamabad locations

A Block, B Block, C Block, D Block, Library, Cafe, Masjid, Cricket Ground, Futsal Ground, CS Lawn, D Block Parking, Faculty Parking, and Other.

Preferred public handover options: Library Entrance, Cafe Entrance, CS Lawn, A/B/C/D Block entrances, Cricket Ground, and Futsal Ground. These are suggested meeting spots, **not** reservations or official collection points.

### Dashboard bonus feature

Foundify shows four counts fetched from the blockchain: **Total Reports, Lost Items, Found Items, Resolved Reports**. The website reads all items and calculates counts in JavaScript; the smart contract does not need extra functions.

## 4. Deploy on Ethereum Sepolia using Remix + MetaMask

You need Chrome/another supported browser with MetaMask, access to the internet, and a small amount of **Sepolia test ETH** for deployment and write transactions. Sepolia ETH is a test token, not real ETH. Never share your wallet seed phrase or private key.

1. Open [Remix IDE](https://remix.ethereum.org).
2. In Remix's file explorer, create a new file named `SmartContract.sol`. Paste in the contents of this project's `SmartContract.sol` file.
3. Open the **Solidity Compiler** tab. Use Solidity compiler version **0.8.24 or newer within 0.8.x** (the file's pragma is `^0.8.24`). Click **Compile SmartContract.sol**.
4. In MetaMask, enable/show test networks if necessary and choose **Sepolia** (chain ID **11155111**). Make sure the selected test account has Sepolia ETH.
5. Open Remix's **Deploy & Run Transactions** tab. Select the browser-wallet environment, which may be labeled **Browser Extension** or **Injected Provider - MetaMask**, depending on Remix's version. Check that Remix is using **Sepolia**, not Remix VM or Ethereum Mainnet.
6. Select contract **Foundify**, keep the transaction value at **0 ETH** (there is no payable constructor), click **Deploy**, and approve the transaction in MetaMask.
7. Wait for confirmation. In Remix's **Deployed Contracts** area, copy the actual deployed contract address. Confirm it appears on [Sepolia Etherscan](https://sepolia.etherscan.io/).
8. Replace the placeholders in **Section 2** of this README with the real contract address, Etherscan link, and your public GitHub URL when available.

**Important:** Do not use a Remix VM deployment address in the frontend. Remix VM is a separate simulated blockchain; Foundify's frontend is configured for public **Ethereum Sepolia**.

## 5. Run the frontend

1. Keep `index.html`, `style.css`, and the `assets/` folder together.
2. For a local run, open the project folder in VS Code and use **Live Server**. Alternatively, in a terminal opened inside `Foundify/` run:

   ```bash
   python -m http.server 8000
   ```

   Then visit `http://localhost:8000/` in the browser with MetaMask. The `python` command may be `python3` on some machines.
3. Paste your **real Sepolia deployed contract address** into the one-time setup field and select **Load contract**.
4. Click **Connect MetaMask**. Allow account access and, when requested, switch to Sepolia.
5. Create a lost or found report. Confirm the MetaMask transaction and wait for its receipt. Refresh the app data if needed.
6. Use another MetaMask account to create a claim; switch back to the reporting wallet to reject the claim or confirm the handover.

The page loads ethers.js v6 from CDN and reads Sepolia through the injected MetaMask provider (if Sepolia is selected), or a public Sepolia RPC when the wallet isn't connected to Sepolia. A working internet connection is needed. Public RPC nodes can occasionally be slow or rate-limited.

## 6. Suggested demonstration for the instructor

Use **two different MetaMask accounts** (both on Sepolia; both funded with enough test ETH for their write actions):

1. **Account A:** Connect, report a **Lost — Black Casio Calculator** at **C Block**, category **Electronics**, preferred handover **Library Entrance**. Notice the successful transaction and how statistics increase.
2. **Account B:** Connect, open the calculator report, and click **I Found This**. The report changes from **Open** to **Claim Pending**. A second claim is not possible while this claim is pending.
3. **Account A:** Go to **My Reports** and open the claim. Demonstrate **Reject claim**, which reopens the report, or **Confirm returned** after an actual/sample handover, which resolves it. Explain why only Account A can review the claim.
4. Show the **Sepolia Etherscan transaction link** to demonstrate that the transaction was recorded on the blockchain.

For a classroom demo, you may use sample objects and *simulate* a handover. Don't claim that an actual campus item was returned if it wasn't. If using sample records, clarify that the **on-chain transactions are real Sepolia testnet transactions**, but the item reports are test data.

## 7. Take the required screenshots (real evidence only)

Save three **genuine screenshots taken in your browser** under `screenshots/`:

- `01-wallet-connected.png` — Foundify showing connected MetaMask on Sepolia and a configured contract address.
- `02-contract-deployment.png` — Remix deployed contract section with the Sepolia deployment address (and optionally transaction on Etherscan).
- `03-claim-transaction.png` — A real successful claim or review interaction, with the status shown in Foundify and/or transaction confirmation and Etherscan link.

The bundled screenshot instructions are placeholders; **the screenshots have not been captured by this project**. You must capture them after you deploy and interact using your own MetaMask wallet.

## 8. Upload to GitHub and submit

1. Create a **public** GitHub repository named something like `foundify-fast-islamabad`.
2. Upload `SmartContract.sol`, `index.html`, `style.css`, `assets/`, `README.md`, and the three real screenshots. Make sure your README has the **actual contract address**.
3. Optionally enable GitHub Pages via repository **Settings → Pages** to host the HTML site. For a simple project, choose deployment from the main branch and `/ (root)`.
4. Download or create a ZIP of the project folder, including the screenshots.
5. Submit the ZIP, public GitHub repository link, and **Sepolia contract address** to Google Classroom as required in the assignment instructions.

## 9. Important limitations

- This is a **testnet demonstration**, not a production lost-and-found service.
- Foundify never asks for a private key or seed phrase; MetaMask signs transactions itself.
- The contract checks wallet permissions but cannot verify actual ownership of physical belongings.
- No automatic matching, wallet-to-wallet messages, or meeting reservations are included.
- Public reports and wallet addresses are visible forever on-chain. Avoid personal/secret data in descriptions.
- Search/filter/statistics use client-side JavaScript. With many thousands of reports, a real production app would need more efficient indexing.
- Use Sepolia only. Do not send real ETH for this assignment.

## Useful references

- [Remix IDE](https://remix.ethereum.org)
- [MetaMask](https://metamask.io)
- [Ethereum Sepolia explorer](https://sepolia.etherscan.io)
- [ethers.js documentation](https://docs.ethers.org/v6/)

---

**Summary for an oral demo:** "Foundify solves a familiar FAST Islamabad campus problem. The Solidity contract keeps tamper-evident lost-and-found records and enforces who may make or review a claim. MetaMask identifies the wallet and signs write transactions. The HTML/JavaScript page reads the contract, filters reports, and displays statistics. We still verify the actual handover in person because blockchain alone can't prove ownership."
