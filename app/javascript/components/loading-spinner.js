const loadingSpinner = () => {
  if(document.querySelector('.loading-bckg')) {
    document.getElementById('avançar').addEventListener('click', () => {
      document.querySelector('.loading-bckg').style.display = 'flex';
    })
  }
}

export { loadingSpinner }