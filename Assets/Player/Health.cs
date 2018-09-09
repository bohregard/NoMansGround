using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Health : MonoBehaviour
{

    [Range(0, 100f)]
    public float HP = 100f;
    public float bulletHp = 0.6f;
    public float rocketHp = 80f;
    // public Text text;
    private Rigidbody rb;

    // Use this for initialization
    void Start()
    {
        rb = gameObject.GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        // text.text = "Health: " + HP;
        if (HP == 0 && !rb.isKinematic)
        {

            // text.enabled = false;
            rb.isKinematic = true;
            rb.freezeRotation = true;
            StartCoroutine("startRespawn");
        }
    }

    public void regen()
    {
        if (HP + 50f > 100f)
        {
            HP = 100f;
        }
        else
        {
            HP += 50f;
        }
    }

    private IEnumerator startRespawn()
    {
        Debug.Log("Start Respawn");
        yield return new WaitForSeconds(3f);
        Debug.Log("Respawning");
        HP = 100f;
        // text.enabled = true;
        rb.isKinematic = false;
        rb.freezeRotation = false;
    }
}
