import numpy as np,struct,math
fs=['ee-e4','ee-03','ee-nivel-mod0']
def mats(f):
    ram=open(f'/home/user/black-datos/{f}.bin','rb').read()
    # El yaw de jugador+0x2F0 YA ESTÁ EN GRADOS (bitácora (67)). La primera versión
    # le aplicaba math.degrees() y el resultado negativo de (65) salió de ahí.
    yaw=struct.unpack_from('<f',ram,0x5A8DA0)[0]%360
    a=np.frombuffer(ram,dtype='<f4'); v=a.reshape(-1,4)
    with np.errstate(all='ignore'):
        ok=np.isfinite(v).all(1); r=v[:,:3]; nr=np.linalg.norm(r,axis=1)
    unit=ok&(np.abs(nr-1)<1e-3)
    out={}
    for i in np.nonzero(unit[:-2]&unit[1:-1]&unit[2:])[0]:
        R=r[i:i+3].astype(float)
        if np.abs(R@R.T-np.eye(3)).max()<1e-3:
            hs=[]
            for vec in (R[0],R[1],R[2],R[:,0],R[:,1],R[:,2]):
                hs.append(math.degrees(math.atan2(vec[0],vec[2])) if abs(vec[1])<0.95 else None)
                hs.append(math.degrees(math.atan2(vec[0],vec[1])) if abs(vec[2])<0.95 else None)
            out[i*16]=hs
    return yaw,out
D=[mats(f) for f in fs]
w=lambda x:((x+180)%360)-180
for k,(i,j) in enumerate(((0,1),(0,2),(1,2))):
    (y1,m1),(y2,m2)=D[i],D[j]
    n=0
    for a in set(m1)&set(m2):
        for c in range(12):
            h1,h2=m1[a][c],m2[a][c]
            if h1 is None or h2 is None: continue
            for sg in (1,-1):
                if abs(w((h1-sg*y1)-(h2-sg*y2)))<1.5 and abs(w(h1-h2))>5:
                    n+=1
                    if n<=8: print(fs[i],fs[j],hex(a),'comp',c,'signo',sg,round(h1,1),round(h2,1))
    print(fs[i],fs[j],'coincidencias',n)
print('--- los TRES a la vez')
(y0,m0),(y1,m1),(y2,m2)=D
for a in set(m0)&set(m1)&set(m2):
    for c in range(12):
        hs=[m[a][c] for m in (m0,m1,m2)]
        if None in hs: continue
        for sg in (1,-1):
            o=[w(h-sg*y) for h,y in zip(hs,(y0,y1,y2))]
            if max(abs(w(o[i]-o[0])) for i in (1,2))<2 and abs(w(hs[0]-hs[1]))>5:
                print(hex(a),c,sg,[round(h,1) for h in hs])
