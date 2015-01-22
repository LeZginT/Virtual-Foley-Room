class LeapFinger extends Actor
placeable;

defaultProperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Components.Add(MyLightEnvironment)
    
    Begin Object Class=StaticMeshComponent Name=LeapMotionMesh
        StaticMesh=StaticMesh'GDC_Materials.Meshes.MeshSphere_02'
        Scale=0.05
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