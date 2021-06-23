import Swal from 'sweetalert2';

const initSwal2 = () => {
  const initSweetalert = (selector, options = {}) => {
    const selectorEl = document.querySelector(selector)
    if (selectorEl) {
      options.text = selectorEl.childNodes[1].innerText
      Swal.fire(options);
    }
  };

  initSweetalert('#success', { title: "Done", icon: "success"});
  initSweetalert('#failed', { title: "Failed", icon: "warning"});
}

export {initSwal2};