import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt.js";

const initFlatpick = () => {
  if (document.getElementById("flat_datetime")) {
    const el = document.getElementById("flat_datetime");
    flatpickr(el, {
      enableTime: true,
      altInput: true,
      minDate: "today",
      altFormat: "F j, Y - h:i K",
      dateFormat: "d-m-Y H:i",
      locale: Portuguese,
      minuteIncrement: 15,
    });

    document
      .querySelector(".trade_date")
      .childNodes[2].setAttribute(
        "value",
        document.getElementById("flat_datetime").value
      );
  }
  if (document.getElementById("flat_date")) {
    const el = document.getElementById("flat_date");
    flatpickr(el, {
      enableTime: false,
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "d-m-Y",
      locale: Portuguese,
    });
  }
};

export { initFlatpick };
