const main = async () => {
    // const [owner, randomPerson] = await hre.ethers.getSigners();
    const [owner] = await hre.ethers.getSigners();
    const happinessBiteContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const happinessBiteContract = await happinessBiteContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1'),
    });
    await happinessBiteContract.deployed();

    console.log("Contract deployed to:", happinessBiteContract.address);
    console.log("Contract deployed by:", owner.address);

    /*
     * Get Contract balance
     */
  let contractBalance = await hre.ethers.provider.getBalance(
    happinessBiteContract.address
  );
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  let happinessBiteCount;
  happinessBiteCount = await happinessBiteContract.getTotalHappinessBites();
  console.log(happinessBiteCount.toNumber());

    /*
        * Send Wave
        */
  const hapinessBiteTxn = await happinessBiteContract.happinessBite('This is bite #1');
  await hapinessBiteTxn.wait();

  const hapinessBiteTxn2 = await happinessBiteContract.happinessBite('This is bite #2');
  await hapinessBiteTxn2.wait();

    /*
     * Get Contract balance to see what happened!
     */
  contractBalance = await hre.ethers.provider.getBalance(happinessBiteContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

//   const [_, randomPerson] = await hre.ethers.getSigners();
//   hapinessBiteTxn = await happinessBiteContract.connect(randomPerson).happinessBite('Another message!');
//   await hapinessBiteTxn.wait();

  let allHappinessBites = await happinessBiteContract.getAllHappinessBites();
  console.log(allHappinessBites);

  happinessBiteCount = await happinessBiteContract.getTotalHappinessBites();

    // hapinessBiteTxn = await happinessBiteContract.connect(randomPerson).bite();
    // await hapinessBiteTxn.wait();

  happinessBiteCount = await happinessBiteContract.getTotalHappinessBites();
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();