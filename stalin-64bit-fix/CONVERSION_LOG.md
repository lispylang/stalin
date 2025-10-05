# Stalin 32-bit → 64-bit Conversion Log

**Date:** 2025-10-05 07:34:30
**Input:** ../stalin.c
**Output:** ../stalin-64bit.c

## Summary

- Total lines: 699,719
- Total changes: 3,404

- struct w49 tag field: 1
- pointer casts: 3,002
- alignment calculations: 295
- region_size variables: 106
- vector length fields: 0

## Detailed Changes


### Phase 1

**Line 5886:**
```diff
- {unsigned tag;
+ {uintptr_t tag;
```


### Phase 2

**Line 31956:**
```diff
- if (!(((unsigned)t0)==NULL_TYPE)) goto l1;
+ if (!(((uintptr_t)t0)==NULL_TYPE)) goto l1;
```

**Line 32017:**
```diff
- if (!(((unsigned)t9)==NULL_TYPE)) goto l5;
+ if (!(((uintptr_t)t9)==NULL_TYPE)) goto l5;
```

**Line 32097:**
```diff
- if (!(((unsigned)t20)==NULL_TYPE)) goto l10;
+ if (!(((uintptr_t)t20)==NULL_TYPE)) goto l10;
```

**Line 34962:**
```diff
- {r28477.tag = (unsigned)t984;
+ {r28477.tag = (uintptr_t)t984;
```

**Line 34987:**
```diff
- {r28477.tag = (unsigned)t982;
+ {r28477.tag = (uintptr_t)t982;
```

**Line 35062:**
```diff
- {r28477.tag = (unsigned)t976;
+ {r28477.tag = (uintptr_t)t976;
```

**Line 35087:**
```diff
- {r28477.tag = (unsigned)t974;
+ {r28477.tag = (uintptr_t)t974;
```

**Line 35169:**
```diff
- if (t955==FALSE_TYPE) t956.tag = (unsigned)t955;
+ if (t955==FALSE_TYPE) t956.tag = (uintptr_t)t955;
```

**Line 35195:**
```diff
- if (t952==FALSE_TYPE) t953.tag = (unsigned)t952;
+ if (t952==FALSE_TYPE) t953.tag = (uintptr_t)t952;
```

**Line 35314:**
```diff
- {r28477.tag = (unsigned)t913;
+ {r28477.tag = (uintptr_t)t913;
```

**Line 35408:**
```diff
- {r28477.tag = (unsigned)t903;
+ {r28477.tag = (uintptr_t)t903;
```

**Line 35507:**
```diff
- if (t880==FALSE_TYPE) t881.tag = (unsigned)t880;
+ if (t880==FALSE_TYPE) t881.tag = (uintptr_t)t880;
```

**Line 36132:**
```diff
- {r28477.tag = (unsigned)t723;
+ {r28477.tag = (uintptr_t)t723;
```

**Line 36183:**
```diff
- {r28477.tag = (unsigned)t715;
+ {r28477.tag = (uintptr_t)t715;
```

**Line 36234:**
```diff
- {r28477.tag = (unsigned)t707;
+ {r28477.tag = (uintptr_t)t707;
```

**Line 36317:**
```diff
- {r28477.tag = (unsigned)t697;
+ {r28477.tag = (uintptr_t)t697;
```

**Line 36368:**
```diff
- {r28477.tag = (unsigned)t689;
+ {r28477.tag = (uintptr_t)t689;
```

**Line 36419:**
```diff
- {r28477.tag = (unsigned)t681;
+ {r28477.tag = (uintptr_t)t681;
```

**Line 36509:**
```diff
- if (t648==FALSE_TYPE) t649.tag = (unsigned)t648;
+ if (t648==FALSE_TYPE) t649.tag = (uintptr_t)t648;
```

**Line 36561:**
```diff
- if (t639==FALSE_TYPE) t640.tag = (unsigned)t639;
+ if (t639==FALSE_TYPE) t640.tag = (uintptr_t)t639;
```

**Line 36613:**
```diff
- if (t630==FALSE_TYPE) t631.tag = (unsigned)t630;
+ if (t630==FALSE_TYPE) t631.tag = (uintptr_t)t630;
```

**Line 37285:**
```diff
- else t1029->s1.tag = (unsigned)t1033;
+ else t1029->s1.tag = (uintptr_t)t1033;
```

**Line 37349:**
```diff
- else t1009->s1.tag = (unsigned)t1025;
+ else t1009->s1.tag = (uintptr_t)t1025;
```

**Line 37397:**
```diff
- else t1015->s1.tag = (unsigned)t1019;
+ else t1015->s1.tag = (uintptr_t)t1019;
```

**Line 37430:**
```diff
- else t1001->s1.tag = (unsigned)t1009;
+ else t1001->s1.tag = (uintptr_t)t1009;
```

**Line 37462:**
```diff
- else r28454->s1.tag = (unsigned)t1001;
+ else r28454->s1.tag = (uintptr_t)t1001;
```

**Line 38352:**
```diff
- else t1110.tag = (unsigned)t1109;
+ else t1110.tag = (uintptr_t)t1109;
```

**Line 38386:**
```diff
- else t1101->s1.tag = (unsigned)t1105;
+ else t1101->s1.tag = (uintptr_t)t1105;
```

**Line 38438:**
```diff
- else t1094->s1.tag = (unsigned)t1097;
+ else t1094->s1.tag = (uintptr_t)t1097;
```

**Line 38478:**
```diff
- else t1085->s1.tag = (unsigned)t1089;
+ else t1085->s1.tag = (uintptr_t)t1089;
```

**Line 41453:**
```diff
- else t1695.tag = (unsigned)t1694;
+ else t1695.tag = (uintptr_t)t1694;
```

**Line 41517:**
```diff
- else t1682.tag = (unsigned)t1681;
+ else t1682.tag = (uintptr_t)t1681;
```

**Line 45510:**
```diff
- if (!(((unsigned)t2946)==NULL_TYPE)) goto l864;
+ if (!(((uintptr_t)t2946)==NULL_TYPE)) goto l864;
```

**Line 45641:**
```diff
- else r27815.tag = (unsigned)t2928;
+ else r27815.tag = (uintptr_t)t2928;
```

**Line 45662:**
```diff
- else t2924->s1.tag = (unsigned)t2926;
+ else t2924->s1.tag = (uintptr_t)t2926;
```

**Line 47817:**
```diff
- else t2522.tag = (unsigned)t2521;
+ else t2522.tag = (uintptr_t)t2521;
```

**Line 47839:**
```diff
- else t2518->s1.tag = (unsigned)t2520;
+ else t2518->s1.tag = (uintptr_t)t2520;
```

**Line 48166:**
```diff
- else t2420->s1.tag = (unsigned)t2422;
+ else t2420->s1.tag = (uintptr_t)t2422;
```

**Line 48194:**
```diff
- else t2416.tag = (unsigned)t2415;
+ else t2416.tag = (uintptr_t)t2415;
```

**Line 48229:**
```diff
- else t2412->s1.tag = (unsigned)t2414;
+ else t2412->s1.tag = (uintptr_t)t2414;
```

**Line 49522:**
```diff
- else t3124.tag = (unsigned)t3122;
+ else t3124.tag = (uintptr_t)t3122;
```

**Line 49615:**
```diff
- else t3106.value.structure_type24753->s0.tag = (unsigned)t3096;
+ else t3106.value.structure_type24753->s0.tag = (uintptr_t)t3096;
```

**Line 49626:**
```diff
- else t3105.value.structure_type24753->s0.tag = (unsigned)t3095;
+ else t3105.value.structure_type24753->s0.tag = (uintptr_t)t3095;
```

**Line 49637:**
```diff
- else t3104.value.structure_type24753->s0.tag = (unsigned)t3094;
+ else t3104.value.structure_type24753->s0.tag = (uintptr_t)t3094;
```

**Line 49648:**
```diff
- else t3103.value.structure_type24753->s0.tag = (unsigned)t3093;
+ else t3103.value.structure_type24753->s0.tag = (uintptr_t)t3093;
```

**Line 49659:**
```diff
- else t3102.value.structure_type24753->s0.tag = (unsigned)t3092;
+ else t3102.value.structure_type24753->s0.tag = (uintptr_t)t3092;
```

**Line 49670:**
```diff
- else t3101.value.structure_type24753->s0.tag = (unsigned)t3091;
+ else t3101.value.structure_type24753->s0.tag = (uintptr_t)t3091;
```

**Line 49681:**
```diff
- else t3100.value.structure_type24753->s0.tag = (unsigned)t3090;
+ else t3100.value.structure_type24753->s0.tag = (uintptr_t)t3090;
```

**Line 49692:**
```diff
- else t3099.value.structure_type24753->s0.tag = (unsigned)t3089;
+ else t3099.value.structure_type24753->s0.tag = (uintptr_t)t3089;
```

**Line 49703:**
```diff
- else t3098.value.structure_type24753->s0.tag = (unsigned)t3088;
+ else t3098.value.structure_type24753->s0.tag = (uintptr_t)t3088;
```

**Line 49714:**
```diff
- else t3097.value.structure_type24753->s0.tag = (unsigned)t3087;
+ else t3097.value.structure_type24753->s0.tag = (uintptr_t)t3087;
```

**Line 49724:**
```diff
- else a35237->s0.tag = (unsigned)t3086;
+ else a35237->s0.tag = (uintptr_t)t3086;
```

**Line 49845:**
```diff
- else t3050.value.structure_type24753->s0.tag = (unsigned)t3045;
+ else t3050.value.structure_type24753->s0.tag = (uintptr_t)t3045;
```

**Line 49856:**
```diff
- else t3049.value.structure_type24753->s0.tag = (unsigned)t3044;
+ else t3049.value.structure_type24753->s0.tag = (uintptr_t)t3044;
```

**Line 49867:**
```diff
- else t3048.value.structure_type24753->s0.tag = (unsigned)t3043;
+ else t3048.value.structure_type24753->s0.tag = (uintptr_t)t3043;
```

**Line 49878:**
```diff
- else t3047.value.structure_type24753->s0.tag = (unsigned)t3042;
+ else t3047.value.structure_type24753->s0.tag = (uintptr_t)t3042;
```

**Line 49889:**
```diff
- else t3046.value.structure_type24753->s0.tag = (unsigned)t3041;
+ else t3046.value.structure_type24753->s0.tag = (uintptr_t)t3041;
```

**Line 49899:**
```diff
- else a35235->s0.tag = (unsigned)t3040;
+ else a35235->s0.tag = (uintptr_t)t3040;
```

**Line 50517:**
```diff
- switch ((unsigned)t3219)
+ switch ((uintptr_t)t3219)
```

**Line 50563:**
```diff
- if (!(((unsigned)t3222)==EOF_OBJECT_TYPE)) goto l899;
+ if (!(((uintptr_t)t3222)==EOF_OBJECT_TYPE)) goto l899;
```

**Line 50572:**
```diff
- else t3230.tag = (unsigned)t3229;
+ else t3230.tag = (uintptr_t)t3229;
```

**Line 50594:**
```diff
- else t3223->s1.tag = (unsigned)t3226;
+ else t3223->s1.tag = (uintptr_t)t3226;
```

**Line 50808:**
```diff
- else t3256.tag = (unsigned)t3255;
+ else t3256.tag = (uintptr_t)t3255;
```

**Line 50839:**
```diff
- else a667->s1.tag = (unsigned)t3265;
+ else a667->s1.tag = (uintptr_t)t3265;
```

**Line 51311:**
```diff
- if (!(((unsigned)t3283)==NULL_TYPE)) goto l914;
+ if (!(((uintptr_t)t3283)==NULL_TYPE)) goto l914;
```

**Line 52473:**
```diff
- else a34205.tag = (unsigned)t3637;
+ else a34205.tag = (uintptr_t)t3637;
```

**Line 52525:**
```diff
- else t3640->s1.tag = (unsigned)t3643;
+ else t3640->s1.tag = (uintptr_t)t3643;
```

**Line 52535:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52542:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52549:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52556:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52574:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52581:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52588:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52595:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52602:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52609:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52616:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52623:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52630:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52637:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52644:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52651:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52658:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52665:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52672:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52679:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52686:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52693:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52700:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52707:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52714:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52721:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52728:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52735:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52742:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52749:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52756:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```

**Line 52763:**
```diff
- if (!(((unsigned)t3305)==NULL_TYPE))
+ if (!(((uintptr_t)t3305)==NULL_TYPE))
```


... and 3,304 more changes
