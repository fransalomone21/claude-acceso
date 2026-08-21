  // FUN_001e3018  0x001E3018-0x001E3097  (44 bytes)

undefined8 FUN_001e3018(undefined8 param_1,ulong param_2)

{
  undefined8 uVar1;
  
  if (param_2 < 0x21) {
                    /* WARNING: Could not recover jumptable at 0x001e3034. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    uVar1 = (*(code *)(&PTR_LAB_003f8130)[(int)param_2])();
    return uVar1;
  }
  return 0;
}


