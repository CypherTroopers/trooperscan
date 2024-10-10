# Cypherium Explorer
Cypherium Explorer (forked from Blockscout)

Cypherium Explorer URL: [https://cypheriumscan.com](https://cypheriumscan.com)  
Blockchain Explorer for inspecting and analyzing the Cypherium Network.

## About Cypherium Explorer
Cypherium Explorer is an Elixir application that allows users to search transactions, view accounts and balances, and verify smart contracts on the Cypherium network, including all block data and transactions.

## Prerequisites
- Install Docker

## Steps to Run the Explorer
1. `git clone https://github.com/CypherTroopers/trooperscan.git`
2. `cd trooperscan/`
3. Run `docker build -f docker/Dockerfile -t cypherium-explorer:v2 ../` (will take several minutes)
4. Run `source env_mainnet.sh` or `source env_testnet.sh`
5. `cd docker`
6. Run `make -f Makefile.local start` to start the Cypherium Explorer & Postgres container.
7. Confirm the explorer service is running with `docker ps`, which should show two containers (blockscout & postgres db).
8. Access the explorer at: `http://{ip-address}:80` or `http://{domain-name}`.

## License
License: GPL v3.0

This project is licensed under the GNU General Public License v3.0. See the LICENSE file for details.

