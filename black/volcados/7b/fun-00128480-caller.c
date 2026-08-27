  // FUN_00128480  0x00128480-0x0012908F  (3088 bytes)

undefined8 FUN_00128480(undefined8 param_1)

{
  undefined1 uVar1;
  bool bVar2;
  char cVar3;
  int iVar4;
  long lVar5;
  undefined8 uVar6;
  undefined8 uVar7;
  undefined8 extraout_v0_udw;
  undefined8 extraout_v0_udw_00;
  undefined1 auVar8 [16];
  undefined1 auVar9 [16];
  undefined1 auVar10 [16];
  undefined4 uVar11;
  char *pcVar12;
  undefined *puVar13;
  byte bVar14;
  int iVar15;
  int iVar16;
  undefined4 in_s4_udw;
  undefined4 in_register_0000014c;
  undefined4 in_s5_udw;
  undefined4 in_register_0000015c;
  float fVar17;
  float fVar18;
  float fStack_2c0;
  float fStack_2bc;
  undefined4 uStack_2b8;
  undefined4 uStack_2b4;
  undefined2 uStack_1c0;
  undefined1 uStack_1be;
  
  iVar16 = (int)param_1;
  if ((*(int *)(iVar16 + 0x5aa0) == 0x1c) && (lVar5 = FUN_00129de8(), lVar5 == 0)) {
    return 0;
  }
  FUN_001005a0(DAT_0040f0e4);
  switch(*(undefined4 *)(iVar16 + 0x5aa0)) {
  case 1:
  case 0x37:
    break;
  default:
    goto switchD_00128508_caseD_2;
  case 5:
    goto switchD_00128508_caseD_5;
  case 6:
    goto switchD_00128508_caseD_6;
  case 7:
    goto switchD_00128508_caseD_7;
  case 8:
    goto switchD_00128508_caseD_8;
  case 9:
    if (*(int *)(iVar16 + 0x5aec) == 0) {
      lVar5 = FUN_00108458(DAT_0040f4c4,6,*(undefined1 *)(iVar16 + 0x5aac));
      *(int *)(iVar16 + 0x5aec) = (int)lVar5;
      if (lVar5 == 0) {
        return 0;
      }
    }
    goto LAB_00128820;
  case 10:
    goto switchD_00128508_caseD_a;
  case 0xb:
    goto switchD_00128508_caseD_b;
  case 0xc:
    if (*(int *)(iVar16 + 0x5af0) == 0) {
      lVar5 = FUN_00108458(DAT_0040f4c4,0xb,
                           (int)((int)((uint)*(byte *)(iVar16 + 0x5aac) << 0x18) >> 8 |
                                (uint)*(byte *)(iVar16 + 0x5aad) << 0x18) >> 0x10);
      *(int *)(iVar16 + 0x5af0) = (int)lVar5;
      if (lVar5 == 0) {
        return 0;
      }
    }
    goto LAB_00128940;
  case 0xd:
    goto switchD_00128508_caseD_d;
  case 0xe:
    goto switchD_00128508_caseD_e;
  case 0xf:
    if (*(int *)(iVar16 + 0x5af4) == 0) {
      uVar6 = FUN_0012d508(param_1);
      lVar5 = FUN_00108458(DAT_0040f4c4,0xc,uVar6);
      *(int *)(iVar16 + 0x5af4) = (int)lVar5;
      if (lVar5 == 0) {
        return 0;
      }
    }
    goto LAB_00128c20;
  case 0x10:
    goto switchD_00128508_caseD_10;
  case 0x11:
    goto switchD_00128508_caseD_11;
  case 0x12:
    goto switchD_00128508_caseD_12;
  case 0x13:
    goto switchD_00128508_caseD_13;
  case 0x14:
    goto switchD_00128508_caseD_14;
  case 0x15:
    goto switchD_00128508_caseD_15;
  case 0x16:
switchD_00128508_caseD_16:
    lVar5 = FUN_0010f860(DAT_0040f4bc);
    if (lVar5 == 0) {
      return 0;
    }
    *(undefined4 *)(iVar16 + 0x5aa0) = 0x1c;
    *(undefined4 *)(iVar16 + 0x5aa4) = 0x1d;
    *(undefined8 *)(iVar16 + 0x5c98) = 0;
    *(undefined8 *)(iVar16 + 0x5c80) = 0;
    *(undefined8 *)(iVar16 + 0x5c88) = 0;
    *(undefined8 *)(iVar16 + 0x5c90) = 0;
switchD_00128508_caseD_1c:
    return 1;
  case 0x1c:
    goto switchD_00128508_caseD_1c;
  }
  if (DAT_0040d9a8 == '\0') {
    FUN_0027b950(0,0,DAT_003c09e8 + 4,0x3bcb14,0x3f4320,0x3f4338,
                 PTR_s____Export_ValueDB_Sound_ps2_DSP__003bda08,0,0);
    DAT_0040d9a8 = '\x01';
  }
  FUN_0027f7d0(param_1);
  FUN_00382348(iVar16 + 0x5ad8,0x2b9d6f8);
  *(undefined4 *)(iVar16 + 0x5ae0) = 0;
  *(undefined4 *)(iVar16 + 0x5ae4) = 0xffffffff;
  uVar1 = *(undefined1 *)(DAT_0040f0e0 + 0x2020c);
  *(undefined1 *)(iVar16 + 0x5aac) = uVar1;
  *(undefined1 *)(iVar16 + 0x5aad) = *(undefined1 *)(DAT_0040f0e0 + 0x2020e);
  *(uint *)(iVar16 + 0x5ab0) = (uint)*(byte *)(DAT_0040f0e0 + 0x2020d);
  iVar4 = FUN_00103358(DAT_0040f0e0,uVar1);
  *(int *)(iVar16 + 0x5ab4) = iVar4;
  iVar15 = *(int *)(iVar16 + 0x5ab0);
  if ((*(byte *)(iVar4 + 0x12) & 1) == 0) {
    iVar15 = iVar15 + 1;
  }
  *(char *)(iVar16 + 0x5aae) = (char)iVar15 - (char)(iVar15 / 2 << 1);
  *(undefined4 *)(*(char *)(iVar16 + 0x5aae) * 0x880 + iVar16 + 0x4994) =
       *(undefined4 *)(iVar16 + 0x5ab0);
  bVar14 = *(byte *)(iVar16 + 0x5aae) ^ 1;
  *(byte *)(iVar16 + 0x5aae) = bVar14;
  if ((long)*(int *)(iVar16 + 0x5ab0) < (long)*(char *)(*(int *)(iVar16 + 0x5ab4) + 0x11)) {
    *(int *)((char)bVar14 * 0x880 + iVar16 + 0x4994) = *(int *)(iVar16 + 0x5ab0) + 1;
    *(byte *)(iVar16 + 0x5aae) = *(byte *)(iVar16 + 0x5aae) ^ 1;
  }
  else {
    *(undefined4 *)((char)bVar14 * 0x880 + iVar16 + 0x4994) = 0xffffffff;
  }
  FUN_0025b5d0(DAT_0040f4cc);
  *(undefined4 *)(iVar16 + 0x5aa0) = 5;
switchD_00128508_caseD_5:
  lVar5 = FUN_0015cab0(DAT_0040f4e0);
  if (lVar5 != 0) {
    *(undefined4 *)(iVar16 + 0x5aa0) = 6;
switchD_00128508_caseD_6:
    iVar15 = iVar16 + 0x5abc;
    iVar4 = 1;
    FUN_0015cec8(DAT_0040f4e0);
    FUN_00272b78(iVar16 + 0x4920);
    FUN_00165de8(DAT_0040f4f4);
    FUN_0016d958(DAT_0040f4d4);
    FUN_0012f3c8(DAT_0040f534);
    FUN_0012ef28(DAT_0040f538);
    do {
      iVar4 = iVar4 + -1;
      FUN_0014db40(iVar15);
      iVar15 = iVar15 + 8;
    } while (-1 < iVar4);
    FUN_00153190(iVar16 + 0x5acc);
    *(undefined4 *)(iVar16 + 0x5aa0) = 7;
switchD_00128508_caseD_7:
    lVar5 = FUN_001386c8(DAT_0040f514);
    if (lVar5 != 0) {
      *(undefined4 *)(iVar16 + 0x5aa0) = 8;
switchD_00128508_caseD_8:
      lVar5 = FUN_00108458(DAT_0040f4c4,6,*(undefined1 *)(iVar16 + 0x5aac));
      *(int *)(iVar16 + 0x5aec) = (int)lVar5;
      if (lVar5 == 0) {
        if ((*(char *)(DAT_0040f4c4 + 0xb38) != '\0') ||
           (bVar2 = false, *(char *)(DAT_0040f4c4 + 0xb39) != '\0')) {
          bVar2 = true;
        }
        if (bVar2) {
          return 0;
        }
        FUN_0035d728(&fStack_2c0,0x3f4348,*(undefined1 *)(iVar16 + 0x5aac));
        FUN_001093c0(DAT_0040f4c4,&fStack_2c0,8,7,0x12a310,param_1,1,0x2000000);
        FUN_0035d728(&uStack_1c0,0x3f4368,*(undefined1 *)(iVar16 + 0x5aac));
        FUN_00144038(DAT_0040f540,&uStack_1c0);
        uVar11 = 9;
LAB_00128be0:
        *(undefined4 *)(iVar16 + 0x5aa0) = uVar11;
        return 0;
      }
LAB_00128820:
      *(undefined4 *)(iVar16 + 0x5aa0) = 10;
switchD_00128508_caseD_a:
      lVar5 = FUN_001e87a0(*(undefined4 *)(DAT_0040f510 + 0xcbd8),0);
      if (lVar5 != 0) {
        *(undefined4 *)(iVar16 + 0x5aa0) = 0xb;
switchD_00128508_caseD_b:
        lVar5 = FUN_00108458(DAT_0040f4c4,0xb,
                             (int)((int)((uint)*(byte *)(iVar16 + 0x5aac) << 0x18) >> 8 |
                                  (uint)*(byte *)(iVar16 + 0x5aad) << 0x18) >> 0x10);
        *(int *)(iVar16 + 0x5af0) = (int)lVar5;
        if (lVar5 == 0) {
          if ((*(char *)(DAT_0040f4c4 + 0xb38) != '\0') ||
             (bVar2 = false, *(char *)(DAT_0040f4c4 + 0xb39) != '\0')) {
            bVar2 = true;
          }
          if (bVar2) {
            return 0;
          }
          FUN_0035d728(&fStack_2c0,0x3f4388,*(undefined1 *)(iVar16 + 0x5aac),
                       *(undefined1 *)(iVar16 + 0x5aad));
          FUN_001093c0(DAT_0040f4c4,&fStack_2c0,8,8,0x12a418,param_1,1,0x2000000);
          uVar11 = 0xc;
          goto LAB_00128be0;
        }
LAB_00128940:
        FUN_001e2d38(*(undefined4 *)(*(int *)(DAT_0040f510 + 0xcbd8) + 0x14),
                     *(undefined4 *)(iVar16 + 0x5af0));
        FUN_00139190(DAT_0040f514,*(undefined4 *)(*(int *)(iVar16 + 0x5af0) + 0xc),1);
        if (0 < *(int *)(*(int *)(*(int *)(iVar16 + 0x5af0) + 0x10) + 8)) {
          iVar15 = *(int *)(iVar16 + 0x5af0);
          iVar4 = 0;
          while( true ) {
            FUN_00272488(*(undefined8 *)(iVar4 * 0x10 + *(int *)(*(int *)(iVar15 + 0x10) + 0xc)),
                         &fStack_2c0);
            if (uStack_2b8._3_1_ == ' ') {
              pcVar12 = (char *)((int)&uStack_2b8 + 3);
              uStack_2b8 = (float)((uint)uStack_2b8 & 0xffffff);
              while (pcVar12 = pcVar12 + -1, *pcVar12 == ' ') {
                *pcVar12 = '\0';
              }
            }
            uVar6 = FUN_00110858(DAT_0040f4bc);
            uVar7 = FUN_00383738(*(undefined4 *)(*(int *)(iVar16 + 0x5af0) + 0x10),iVar4);
            FUN_0010f708(uVar6,uVar7,&fStack_2c0);
            if (*(int *)(*(int *)(*(int *)(iVar16 + 0x5af0) + 0x10) + 8) <= iVar4 + 1) break;
            iVar15 = *(int *)(iVar16 + 0x5af0);
            iVar4 = iVar4 + 1;
          }
        }
        *(undefined4 *)(iVar16 + 0x5aa0) = 0xd;
switchD_00128508_caseD_d:
        lVar5 = FUN_001abc28(DAT_0040f50c);
        if (lVar5 != 0) {
          *(undefined4 *)(iVar16 + 0x5aa0) = 0xe;
switchD_00128508_caseD_e:
          if (*(char *)(iVar16 + 0x5aac) < '2') {
            *(undefined1 *)(iVar16 + 0x5ca0) = 0;
            for (iVar15 = *(int *)(DAT_0040f0e0 + 0x2014c); iVar15 < 4; iVar15 = iVar15 + 1) {
              cVar3 = FUN_00123bf0(0x48efa8,iVar15);
              if (cVar3 != '\0') {
                *(undefined1 *)(iVar16 + 0x5ca0) = 1;
              }
            }
            if (*(int *)(DAT_0040f0e0 + 0x2014c) == 3) {
              *(undefined1 *)(iVar16 + 0x5ca0) = 1;
            }
            cVar3 = FUN_00123bf0(0x48efa8,3);
            if ((cVar3 == '\0') && (*(int *)(DAT_0040f0e0 + 0x2014c) != 3)) {
              *(undefined1 *)(iVar16 + 0x5ca1) = 0;
            }
            else {
              *(undefined1 *)(iVar16 + 0x5ca1) = 1;
            }
          }
          else {
            *(undefined1 *)(iVar16 + 0x5ca0) = 0;
            *(undefined1 *)(iVar16 + 0x5ca1) = 0;
          }
          uVar6 = FUN_0012d508(param_1);
          lVar5 = FUN_00108458(DAT_0040f4c4,0xc,uVar6);
          *(int *)(iVar16 + 0x5af4) = (int)lVar5;
          if (lVar5 == 0) {
            if (*(char *)(iVar16 + 0x5ca0) == '\0') {
              uStack_1c0 = (ushort)uStack_1c0._1_1_ << 8;
            }
            else {
              uStack_1c0 = DAT_003f43b0;
              uStack_1be = DAT_003f43b2;
            }
            if ((*(char *)(DAT_0040f4c4 + 0xb38) != '\0') ||
               (bVar2 = false, *(char *)(DAT_0040f4c4 + 0xb39) != '\0')) {
              bVar2 = true;
            }
            if (bVar2) {
              return 0;
            }
            FUN_0035d728(&fStack_2c0,0x3f43b8,*(undefined1 *)(iVar16 + 0x5aac),
                         *(undefined1 *)(iVar16 + 0x5aad),&uStack_1c0);
            FUN_001093c0(DAT_0040f4c4,&fStack_2c0,8,0x19,0x12a480,param_1,1,0x2000000);
            uVar11 = 0xf;
            goto LAB_00128be0;
          }
LAB_00128c20:
          *(undefined4 *)(iVar16 + 0x5aa0) = 0x10;
switchD_00128508_caseD_10:
          lVar5 = FUN_0012d5a8(iVar16 + 0x4990);
          if (lVar5 != 0) {
            *(undefined4 *)(iVar16 + 0x5aa0) = 0x11;
switchD_00128508_caseD_11:
            if ((*(char *)(iVar16 + 0x5aae) != '\x01') ||
               (lVar5 = FUN_0012d5a8(iVar16 + 0x5210), lVar5 != 0)) {
              *(undefined4 *)(iVar16 + 0x5ae8) = 0;
              *(undefined4 *)(iVar16 + 0x5aa0) = 0x12;
              DAT_003bd1b0 = *(float *)(*(int *)(iVar16 + 0x5aec) + 0x354);
              fVar18 = 0.0;
              pcVar12 = &DAT_003f42e0;
              iVar15 = 0;
              DAT_003bd1b4 = *(undefined4 *)(*(int *)(iVar16 + 0x5aec) + 0x358);
              DAT_003bd1b8 = *(float *)(*(int *)(iVar16 + 0x5aec) + 0x35c);
              do {
                fVar17 = (float)(int)*pcVar12 * 0.0078125;
                if (fVar17 < fVar18) {
                  fVar17 = (float)FUN_0029e688(-fVar17,DAT_003bd1b4);
                  fVar17 = -fVar17;
                  uVar6 = extraout_v0_udw;
                }
                else {
                  fVar17 = (float)FUN_0029e688(fVar17,DAT_003bd1b4);
                  uVar6 = extraout_v0_udw_00;
                }
                fVar17 = fVar17 * DAT_003bd1b0;
                if (iVar15 == 0) {
                  fVar17 = fVar17 + DAT_003bd1b8;
                }
                puVar13 = &DAT_003bcb08 + iVar15;
                iVar15 = iVar15 + 1;
                pcVar12 = pcVar12 + 1;
                auVar8._0_8_ = (long)(int)(fVar17 * 128.0);
                auVar8._8_8_ = uVar6;
                auVar9._8_4_ = in_s5_udw;
                auVar9._0_8_ = 0xffffffffffffff80;
                auVar9._12_4_ = in_register_0000015c;
                auVar9 = _pmaxw(auVar8,auVar9);
                auVar10._8_4_ = in_s4_udw;
                auVar10._0_8_ = 0x7f;
                auVar10._12_4_ = in_register_0000014c;
                auVar10 = _pminw(auVar9,auVar10);
                auVar10 = _pextlw(0,auVar10._0_8_);
                *puVar13 = auVar10[0];
              } while (iVar15 < 9);
              DAT_003bd1ac = *(undefined4 *)(*(int *)(iVar16 + 0x5aec) + 0x368);
              DAT_003bd1a4 = *(undefined4 *)(*(int *)(iVar16 + 0x5aec) + 0x360);
              DAT_003bd1a8 = *(undefined4 *)(*(int *)(iVar16 + 0x5aec) + 0x364);
              iVar15 = *(int *)(iVar16 + 0x5aec);
              FUN_001b0fa8(*(undefined4 *)(iVar15 + 900),iVar16 + 0x5b00,
                           *(undefined4 *)(iVar15 + 0x378),*(undefined4 *)(iVar15 + 0x37c),
                           *(undefined4 *)(iVar15 + 0x380));
              fVar18 = *(float *)(*(int *)(iVar16 + 0x5aec) + 0x36c);
              fVar18 = (float)((int)fVar18 * (uint)(-0.5 < fVar18) |
                              (uint)(-0.5 >= fVar18) * -0x41000000);
              DAT_003bd1bc = (float)((int)fVar18 * (uint)(fVar18 < 0.5) |
                                    (uint)(fVar18 >= 0.5) * 0x3f000000);
              DAT_00415b60 = DAT_003bd1bc + 1.0;
              fVar18 = *(float *)(*(int *)(iVar16 + 0x5aec) + 0x370);
              fVar18 = (float)((int)fVar18 * (uint)(-0.5 < fVar18) |
                              (uint)(-0.5 >= fVar18) * -0x41000000);
              DAT_003bd1c0 = (float)((int)fVar18 * (uint)(fVar18 < 0.5) |
                                    (uint)(fVar18 >= 0.5) * 0x3f000000);
              DAT_00415b64 = DAT_003bd1c0 + 1.0;
              fVar18 = *(float *)(*(int *)(iVar16 + 0x5aec) + 0x374);
              fVar18 = (float)((int)fVar18 * (uint)(-0.5 < fVar18) |
                              (uint)(-0.5 >= fVar18) * -0x41000000);
              DAT_003bd1c4 = (float)((int)fVar18 * (uint)(fVar18 < 0.5) |
                                    (uint)(fVar18 >= 0.5) * 0x3f000000);
              DAT_00415b68 = DAT_003bd1c4 + 1.0;
              uStack_2b4 = 0x3f800000;
              DAT_00415b6c = 0x3f800000;
              fVar18 = *(float *)(*(int *)(iVar16 + 0x5aec) + 0x388);
              fVar18 = (float)((int)fVar18 * (uint)(0.0 < fVar18));
              DAT_003bd1d4 = (int)fVar18 * (uint)(fVar18 < 1.0) | (uint)(fVar18 >= 1.0) * 0x3f800000
              ;
              fVar18 = *(float *)(*(int *)(iVar16 + 0x5aec) + 0x38c);
              fVar18 = (float)((int)fVar18 * (uint)(0.0 < fVar18));
              DAT_003bd1d8 = (int)fVar18 * (uint)(fVar18 < 1.0) | (uint)(fVar18 >= 1.0) * 0x3f800000
              ;
              fStack_2c0 = DAT_00415b60;
              fStack_2bc = DAT_00415b64;
              uStack_2b8 = DAT_00415b68;
              FUN_001af580(DAT_0040f4c0 + 0x14,0x3f43e0);
switchD_00128508_caseD_12:
              if (*(int *)(iVar16 + 0x5ae8) < *(int *)(DAT_0040f0e0 + 0x20208)) {
                lVar5 = FUN_00129090(param_1);
                if (lVar5 == 0) {
                  return 0;
                }
                *(int *)(iVar16 + 0x5ae8) = *(int *)(iVar16 + 0x5ae8) + 1;
              }
              *(undefined4 *)(iVar16 + 0x5aa0) = 0x13;
switchD_00128508_caseD_13:
              lVar5 = FUN_001b1b28(DAT_0040f4d8,*(undefined4 *)(*(int *)(iVar16 + 0x5aec) + 0x350));
              if (lVar5 != 0) {
                *(undefined4 *)(iVar16 + 0x5aa0) = 0x14;
switchD_00128508_caseD_14:
                lVar5 = FUN_0016ae08(DAT_0040f528);
                if (lVar5 != 0) {
                  *(undefined4 *)(iVar16 + 0x5aa0) = 0x15;
switchD_00128508_caseD_15:
                  FUN_0011a0c8(DAT_0040f508);
                  FUN_0027f818(param_1);
                  FUN_00160738(iVar16 + 0x8f0);
                  FUN_0011a1c0(DAT_0040f530);
                  FUN_0011bf28(DAT_0040f504);
                  FUN_00126290(DAT_0040f4e4);
                  FUN_001f2790(DAT_0040f518,*(undefined1 *)(DAT_0040f0e0 + 0x20208));
                  FUN_001f2340(DAT_0040f518);
                  FUN_001f27f8(DAT_0040f51c);
                  FUN_001f2838(DAT_0040f51c,0,1);
                  if ((*(int *)(DAT_0040f0e0 + 0x21070) == DAT_0040f0e0 + 0x20fd8) ||
                     (*(int *)(DAT_0040f0e0 + 0x21074) == DAT_0040f0e0 + 0x20fd8)) {
                    FUN_001f2898(DAT_0040f51c,0,2);
                  }
                  else {
                    FUN_001f2898(DAT_0040f51c,0,1);
                  }
                  FUN_001b0e00(iVar16 + 0x5b00);
                  FUN_0014d958(DAT_0040f52c);
                  FUN_0012be80(param_1);
                  uVar6 = FUN_00122900(DAT_0040f4e8,*(undefined1 *)(iVar16 + 0x5aac));
                  FUN_0012f908(iVar16 + 0x910,uVar6);
                  *(undefined4 *)(iVar16 + 0x5aa8) = 0;
                  *(undefined4 *)(iVar16 + 0x5aa0) = 0x16;
                  goto switchD_00128508_caseD_16;
                }
              }
            }
          }
        }
      }
    }
  }
switchD_00128508_caseD_2:
  return 0;
}


