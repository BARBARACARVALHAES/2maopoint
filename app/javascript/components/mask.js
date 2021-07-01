import $ from "jquery";
import "jquery-mask-plugin";

var initiMask = function () {
  $(".time").mask("00:00:00");
  $(".date_time").mask("00/00/0000");
  $(".cep").mask("00000-000");
  $(".phone").mask("(00) (00000-0000");
  $(".phone_with_ddd").mask("+55 (00) 00000-0000");
  $(".phone_us").mask("(000) 000-0000");
  $(".mixed").mask("AAA 000-S0S");
  $(".cpf").mask("000.000.000-00", { reverse: true });
  $(".money").mask("000.000.000.000.000,00", { reverse: true });
};

console.log("buuuuu");

export { initiMask };
