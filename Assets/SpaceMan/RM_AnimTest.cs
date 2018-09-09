using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RM_AnimTest : MonoBehaviour {

    public Animator anim;

    public string Anim1;
    public string Anim2;
    public string Anim3;
    public string Anim4;

	
	
	void Update ()
    {
		if (Input.GetKey(KeyCode.Alpha1))
        {
            anim.Play("SpaceMan_Hit");
        }

        if (Input.GetKey(KeyCode.Alpha2))
        {
            anim.Play("SpaceMan_Death");
            Debug.Log("Anim2 should be playing");
        }

        if (Input.GetKey(KeyCode.Alpha3))
        {
            anim.Play(Anim3);
        }

        if (Input.GetKey(KeyCode.Alpha4))
        {
            anim.Play(Anim4);
        }


    }
}
