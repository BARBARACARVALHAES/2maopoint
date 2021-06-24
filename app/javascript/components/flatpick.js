import flatpickr from "flatpickr";

const initFlatpick = () => {
  const el = document.getElementById("flat_date");
  if(document.getElementById("flat_date")) {
    flatpickr(el, {
      enableTime: true,
      altInput: true,
      minDate: "today",
      altFormat: "F j, Y at h:i K",
      dateFormat: "Y-m-d H:i",
      defaultHour: 23,
      defaultMinute: 59,
      minuteIncrement: 1,
    });
  }
};

export { initFlatpick };
