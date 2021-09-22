# Мастермост

## 

Deal - прикладной СмК описывающий процесс передачи актива из сети источника в сеть назначения
Mastermost - системный СмК принимает сообщения из прикладных СмК и создаёт события для оракула
## Сборка

```bash
npm install # yarn
npx hardhat compile # запуск сборки
npx hardhat test # запуск тестов
npx hardhat node # запуск узла
npx hardhat run scripts/deploy.js --network localhost # развёртывание смарт-контракта в локальной сети

```

