  // FUN_001e2d38  0x001E2D38-0x001E2F03  (460 bytes)

void FUN_001e2d38(undefined8 param_1,int param_2)

{
  undefined8 uVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  
  iVar6 = (int)param_1;
  *(int *)(iVar6 + 0x288) = param_2;
  iVar7 = 0;
  if (0 < *(int *)(param_2 + 8)) {
    iVar3 = *(int *)(iVar6 + 0x288);
    do {
      iVar4 = iVar7 * 0x28;
      iVar7 = iVar7 + 1;
      iVar4 = *(int *)(iVar3 + 4) + iVar4;
      iVar3 = 0;
      if (0 < *(int *)(iVar4 + 0x20)) {
        iVar5 = 0;
        iVar2 = *(int *)(iVar4 + 0x18);
        while( true ) {
          iVar2 = iVar2 + iVar5;
          iVar5 = iVar5 + 0xb0;
          uVar1 = FUN_001e3018(param_1,*(undefined4 *)(iVar2 + 0x88));
          FUN_0035d728(iVar2,0x3f8108,iVar3,uVar1);
          iVar3 = iVar3 + 1;
          FUN_0027b950(0,0,DAT_003c09e8 + 4,iVar2 + 0x94,iVar2,iVar4,
                       PTR_s____Export_ValueDB_Sound_ps2_AIWe_003bd3b8,0,0);
          if (*(int *)(iVar4 + 0x20) <= iVar3) break;
          iVar2 = *(int *)(iVar4 + 0x18);
        }
      }
      iVar3 = 0;
      if (0 < *(int *)(iVar4 + 0x24)) {
        iVar5 = 0;
        iVar2 = *(int *)(iVar4 + 0x1c);
        while( true ) {
          iVar2 = iVar2 + iVar5;
          iVar5 = iVar5 + 0xb0;
          uVar1 = FUN_001e3018(param_1,*(undefined4 *)(iVar2 + 0x88));
          FUN_0035d728(iVar2,0x3f8118,iVar3,uVar1);
          iVar3 = iVar3 + 1;
          FUN_0027b950(0,0,DAT_003c09e8 + 4,iVar2 + 0x94,iVar2,iVar4,
                       PTR_s____Export_ValueDB_Sound_ps2_AIWe_003bd3b8,0,0);
          if (*(int *)(iVar4 + 0x24) <= iVar3) break;
          iVar2 = *(int *)(iVar4 + 0x1c);
        }
      }
      iVar3 = *(int *)(iVar6 + 0x288);
    } while (iVar7 < *(int *)(iVar3 + 8));
  }
  return;
}


