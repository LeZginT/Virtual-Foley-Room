class LeapActor extends Actor
placeable;

defaultProperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Components.Add(MyLightEnvironment)
    
    Begin Object Class=StaticMeshComponent Name=LeapMesh
        StaticMesh=StaticMesh'GDC_Materials.Meshes.MeshSphere_02'
        Scale=0.1
        LightEnvironMent=MyLightEnvironment
    End Object
    Components.Add(LeapMesh)
    
    CollisionComponent=LeapMesh;
    bCollideWorld=true
    bCollideActors = true
    bBlockActors = true
    BlockRigidBody = true
    bNoEncroachCheck= true
   
    Physics=PHYS_Projectile
    bStatic=false
    bMovable=true
}