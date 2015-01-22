class LeapMotionActor extends Actor
placeable;

defaultProperties
{
    //Begin Object Class=StaticMeshComponent Name=LeapMotionMesh
    //StaticMesh=StaticMesh'LT_Light.SM.Mesh.S_LT_Light_SM_Light01'
    //End Object
    //Components.Add(LeapMotionMesh)
    
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Components.Add(MyLightEnvironment)
    
    Begin Object Class=StaticMeshComponent Name=LeapMotionMesh
        StaticMesh=StaticMesh'GDC_Materials.Meshes.MeshSphere_02'
        //StaticMesh=StaticMesh'HU_Deco_Statues.SM.Mesh.S_HU_Deco_Statues_SM_Statue03_01'
        //StaticMesh=StaticMesh'WP_ShockRifle.Mesh.S_Sphere_Good'
        Scale=0.1
        LightEnvironMent=MyLightEnvironment
    End Object
    Components.Add(LeapMotionMesh)
    
    CollisionComponent=LeapMotionMesh;
    bCollideWorld=true
    bCollideActors = true
    bBlockActors = true
    BlockRigidBody = true
    bNoEncroachCheck= true
   
    Physics=PHYS_Projectile
    bStatic=False
    bMovable=True
    
}