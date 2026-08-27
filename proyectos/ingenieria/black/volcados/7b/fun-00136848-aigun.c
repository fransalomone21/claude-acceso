  // FUN_00136848  0x00136848-0x001368EF  (168 bytes)

void FUN_00136848(undefined8 param_1,long param_2)

{
  undefined8 uVar1;
  long lVar2;
  undefined1 auStack_140 [256];
  undefined1 auStack_40 [16];
  
  if (param_2 != 0) {
    uVar1 = FUN_00272610(param_2,0xe69a1dd748000000);
    lVar2 = FUN_00108120(DAT_0040f4c4,uVar1);
    if (lVar2 == 0) {
      FUN_00272488(uVar1,auStack_40,0);
      FUN_0035d728(auStack_140,0x3f4848,auStack_40);
    }
    else {
      FUN_00135c78(param_1,0,lVar2,0);
      *(undefined1 *)((int)param_1 + 0x3b4) = 0;
    }
  }
  return;
}


