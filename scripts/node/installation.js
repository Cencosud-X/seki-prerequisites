module.exports = (runner) => {
  return new Promise((resolve)=>{
    const paths = await runner.execSync('echo $PATH');
    console.log(paths);
    resolve(true);
  })
}