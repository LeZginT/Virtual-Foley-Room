class LeapActor extends Actor
placeable;

defaultProperties
{
    //Begin Object Class=StaticMeshComponent Name=LeapMesh
        //StaticMesh=StaticMesh'FoliageDemo.Mesh.S_BananaPlant_01'
        //End Object
    //Components.Add(LeapMesh)
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Components.Add(MyLightEnvironment)
    
    Begin Object Class=SkeletalMeshComponent Name=LeapMesh
    SkeletalMesh=SkeletalMesh'FoliageDemo.Animated.SP_Bird1_SKMesh'
    LightEnvironment = MyLightEnvironment
    End Object
    Components.Add(LeapMesh)
    
    CollisionComponent=LeapMesh;
   bCollideWorld=true
   Physics=PHYS_Projectile
   bStatic=False
   bMovable=True

}